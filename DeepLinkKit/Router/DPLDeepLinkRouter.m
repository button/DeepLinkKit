#import "DPLDeepLinkRouter.h"
#import "DPLRouteMatcher.h"
#import "DPLDeepLink.h"
#import "DPLRouteHandler.h"
#import "DPLErrors.h"
#import <objc/runtime.h>

@interface DPLDeepLinkRouter ()

@property (nonatomic, copy) DPLApplicationCanHandleDeepLinksBlock applicationCanHandleDeepLinksBlock;

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

- (void)registerHandlerClass:(Class)handlerClass forRoute:(NSString *)route {

    if (handlerClass && [handlerClass isSubclassOfClass:[DPLRouteHandler class]] && [route length]) {
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

- (BOOL)handleURL:(NSURL *)url withCompletion:(DPLRouteCompletionBlock)completionHandler {
    if (!url) {
        return NO;
    }
    
    if (![self applicationCanHandleDeepLinks]) {
        [self completeRouteWithSuccess:NO error:nil completionHandler:completionHandler];
        return NO;
    }
    
    DPLDeepLink *deepLink = nil;
    BOOL isHandled = NO;
    for (NSString *route in self.routes) {
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:route];
        deepLink = [matcher deepLinkWithURL:url];
        if (deepLink) {
            isHandled = YES;
            __weak __typeof(self) weakSelf = self;
            [self handleRoute:route deepLink:deepLink withCompletion:^(BOOL handled, NSError *error) {
                [weakSelf completeRouteWithSuccess:handled error:error completionHandler:completionHandler];
            }];
            break;
        }
    }

    if (!deepLink) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"The passed URL does not match a registered route.", nil) };
        NSError *error = [NSError errorWithDomain:DPLErrorDomain code:DPLRouteNotFoundError userInfo:userInfo];
        [self completeRouteWithSuccess:isHandled error:error completionHandler:completionHandler];
    }
    
    return isHandled;
}

- (BOOL)handleUserActivity:(NSUserActivity *)userActivity withCompletion:(DPLRouteCompletionBlock)completionHandler {
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        return [self handleURL:userActivity.webpageURL withCompletion:completionHandler];
    }
    
    return NO;
}

- (void)handleRoute:(NSString *)route deepLink:(DPLDeepLink *)deepLink withCompletion:(DPLRouteCompletionBlock)completionHandler {
    
    id handler = self[route];
    
    if ([handler isKindOfClass:NSClassFromString(@"NSBlock")]) {
        DPLRouteHandlerBlock routeHandlerBlock = handler;
        routeHandlerBlock(deepLink);
        
        completionHandler(YES, nil);
    }
    else if (class_isMetaClass(object_getClass(handler)) &&
             [handler isSubclassOfClass:[DPLRouteHandler class]]) {
        DPLRouteHandler *routeHandler = [[handler alloc] init];

        if (![routeHandler shouldHandleDeepLink:deepLink]) {
            completionHandler(NO, nil);
        }
        
        UIViewController *presentingViewController = [routeHandler viewControllerForPresentingDeepLink:deepLink];
        
        //This block will be either called synchronously or asynchronously, depending upon
        //the desire of the route handler implementation
        void (^handyBlock)(UIViewController <DPLTargetViewController> *) = ^(UIViewController <DPLTargetViewController> *targetViewController) {
            if (targetViewController) {
                [targetViewController configureWithDeepLink:deepLink];
                [routeHandler presentTargetViewController:targetViewController inViewController:presentingViewController];
                
                completionHandler(YES, nil);
            }
            else {
                
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"The matched route handler does not specify a target view controller.", nil)};
                NSError *error = [NSError errorWithDomain:DPLErrorDomain code:DPLRouteHandlerTargetNotSpecifiedError userInfo:userInfo];
                
                completionHandler(NO, error);
            }
        };
        
        if (routeHandler.preferAsynchronous) {
            [routeHandler targetViewControllerWithCompletion:^(UIViewController <DPLTargetViewController> *targetViewController) {
                handyBlock(targetViewController);
            }];
        } else {
            UIViewController <DPLTargetViewController> *targetViewController = [routeHandler targetViewController];
            handyBlock(targetViewController);
        }
    }
}

- (void)completeRouteWithSuccess:(BOOL)handled error:(NSError *)error completionHandler:(DPLRouteCompletionBlock)completionHandler {
    if (completionHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(handled, error);
        });
    }
}

@end
