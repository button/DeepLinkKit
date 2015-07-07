#import "DPLDeepLinkRouter.h"
#import "DPLRouteMatcher.h"
#import "DPLDeepLink.h"
#import "DPLRouteHandler.h"
#import "DPLErrors.h"
#import <objc/runtime.h>

@interface DPLDeepLinkRouter ()

@property (nonatomic, copy) DPLApplicationCanHandleDeepLinksBlock applicationCanHandleDeepLinksBlock;
@property (nonatomic, copy) DPLRouteCompletionBlock               routeCompletionHandler;

@property (nonatomic, strong) NSMutableOrderedSet *routes;
@property (nonatomic, strong) NSMutableDictionary *classesByRoute;
@property (nonatomic, strong) NSMutableDictionary *blocksByRoute;

@end


@implementation DPLDeepLinkRouter

- (instancetype)init {
    self = [super init];
    if (self) {
        _routes         = [NSMutableOrderedSet orderedSet];
        _classesByRoute = [NSMutableDictionary dictionary];
        _blocksByRoute  = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark - Configuration

- (BOOL)applicationCanHandleDeepLinks {
    if (self.applicationCanHandleDeepLinksBlock) {
        return self.applicationCanHandleDeepLinksBlock();
    }
    
    return YES;
}


#pragma mark - Registering Routes

- (void)registerHandlerClass:(Class <DPLRouteHandler>)handlerClass forRoute:(NSString *)route {

    if (handlerClass && [route length]) {
        [self.routes addObject:route];
        [self.blocksByRoute removeObjectForKey:route];
        self.classesByRoute[route] = handlerClass;
    }
}


- (void)registerBlock:(DPLRouteHandlerBlock)routeHandlerBlock forRoute:(NSString *)route {

    if (routeHandlerBlock && [route length]) {
        [self.routes addObject:route];
        [self.classesByRoute removeObjectForKey:route];
        self.blocksByRoute[route] = [routeHandlerBlock copy];
    }
}


#pragma mark - Registering Routes via Object Subscripting

- (id)objectForKeyedSubscript:(NSString *)key {

    NSString *route = (NSString *)key;
    id obj = nil;
    
    if ([route isKindOfClass:[NSString class]] && route.length) {
        obj = self.classesByRoute[route];
        if (!obj) {
            obj = self.blocksByRoute[route];
        }
    }
    
    return obj;
}


- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key {
    
    NSString *route = (NSString *)key;
    if (!([route isKindOfClass:[NSString class]] && route.length)) {
        return;
    }
    
    if (!obj) {
        [self.routes removeObject:route];
        [self.classesByRoute removeObjectForKey:route];
        [self.blocksByRoute removeObjectForKey:route];
    }
    else if ([obj isKindOfClass:NSClassFromString(@"NSBlock")]) {
        [self registerBlock:obj forRoute:route];
    }
    else if (class_isMetaClass(object_getClass(obj)) &&
             [obj isSubclassOfClass:[DPLRouteHandler class]]) {
        [self registerHandlerClass:obj forRoute:route];
    }
}


#pragma mark - Routing Deep Links

- (BOOL)handleURL:(NSURL *)url withCompletion:(DPLRouteCompletionBlock)completionHandler; {
    self.routeCompletionHandler = completionHandler;
    if (!url) {
        return NO;
    }
    
    if (![self applicationCanHandleDeepLinks]) {
        [self completeRouteWithSuccess:NO error:nil];
        return NO;
    }

    DPLDeepLink  *deepLink;
    id handler;
    deepLink = [self deepLinkForUrl:url handler:&handler];

    NSError      *error;
    BOOL isHandled = NO;
    if (!deepLink) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"The passed URL does not match a registered route.", nil) };
        error = [NSError errorWithDomain:DPLErrorDomain code:DPLRouteNotFoundError userInfo:userInfo];
    } else {
        isHandled = [self handleRoute:handler withDeepLink:deepLink error:&error];
    }
    
    [self completeRouteWithSuccess:isHandled error:error];
    
    return isHandled;
}


- (BOOL)handleUserActivity:(NSUserActivity *)userActivity withCompletion:(DPLRouteCompletionBlock)completionHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        return [self handleURL:userActivity.webpageURL withCompletion:completionHandler];
    }
    
    return NO;
}

- (UIViewController <DPLTargetViewController> *)viewControllerForUrl:(NSURL *)url {
    DPLDeepLink *deepLink;
    id handler;
    deepLink = [self deepLinkForUrl:url handler:&handler];
    if (handler) {
        DPLRouteHandler *routeHandler = [self routeHandlerForHandler:handler];
        if (routeHandler) {
            return [self viewControllerForHandler:routeHandler withDeepLink:deepLink];
        }
    }
    return nil;
}


- (DPLDeepLink *)deepLinkForUrl:(NSURL *)url handler:(id *)handler {
    DPLDeepLink *deepLink;
    for (NSString *route in self.routes) {
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:route];
        deepLink = [matcher deepLinkWithURL:url];
        if (deepLink) {
            *handler = self[route];
            break;
        }
    }
    return deepLink;
}


- (BOOL)handleRoute:(id)handler withDeepLink:(DPLDeepLink *)deepLink error:(NSError *__autoreleasing *)error {
    DPLRouteHandler *routeHandler = [self routeHandlerForHandler:handler];
    if (routeHandler) {
        if (![routeHandler shouldHandleDeepLink:deepLink]) {
            return NO;
        }

        UIViewController *presentingViewController = [routeHandler viewControllerForPresentingDeepLink:deepLink];
        UIViewController <DPLTargetViewController> *targetViewController = [self viewControllerForHandler:routeHandler withDeepLink:deepLink];

        if (targetViewController) {
            [routeHandler presentTargetViewController:targetViewController inViewController:presentingViewController];
        }
        else {

            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"The matched route handler does not specify a target view controller.", nil)};

            if (error) {
                *error = [NSError errorWithDomain:DPLErrorDomain code:DPLRouteHandlerTargetNotSpecifiedError userInfo:userInfo];
            }

            return NO;
        }
    }
    else if ([handler isKindOfClass:NSClassFromString(@"NSBlock")]) {
        DPLRouteHandlerBlock routeHandlerBlock = handler;
        routeHandlerBlock(deepLink);
    }

    return YES;
}


- (DPLRouteHandler *)routeHandlerForHandler:(id)handler {
    if (class_isMetaClass(object_getClass(handler)) &&
            [handler isSubclassOfClass:[DPLRouteHandler class]]) {
        return [[handler alloc] init];
    }
    return nil;
}


- (UIViewController <DPLTargetViewController> *)viewControllerForHandler:(DPLRouteHandler *)routeHandler withDeepLink:(DPLDeepLink *)deepLink {
    UIViewController <DPLTargetViewController> *targetViewController;
    targetViewController = [routeHandler targetViewController];
    [targetViewController configureWithDeepLink:deepLink];
    return targetViewController;
}


- (void)completeRouteWithSuccess:(BOOL)handled error:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.routeCompletionHandler) {
            self.routeCompletionHandler(handled, error);
        }
    });
}

@end
