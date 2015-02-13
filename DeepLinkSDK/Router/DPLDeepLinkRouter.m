#import "DPLDeepLinkRouter.h"
#import "DPLRouteMatcher.h"
#import "DPLDeepLink.h"
#import "DPLRouteHandler.h"
#import "DPLRouteHandlerProtocol.h"
#import "DPLErrors.h"
#import "UINavigationController+DPL.h"
#import <objc/runtime.h>

@interface DPLDeepLinkRouter ()

@property (nonatomic, copy) DPLApplicationCanHandleDeepLinksBlock applicationCanHandleDeepLinksBlock;
@property (nonatomic, copy) DPLRouteCompletionBlock               routeCompletionHandler;

@property (nonatomic, strong) NSMutableOrderedSet *routes;
@property (nonatomic, strong) NSMutableDictionary *classesByRoute;
@property (nonatomic, strong) NSMutableDictionary *blocksByRoute;
@property (nonatomic, strong) NSMutableDictionary *protocolsByRoute;

@end


@implementation DPLDeepLinkRouter

- (instancetype)init {
    self = [super init];
    if (self) {
        _routes           = [NSMutableOrderedSet orderedSet];
        _classesByRoute   = [NSMutableDictionary dictionary];
        _blocksByRoute    = [NSMutableDictionary dictionary];
        _protocolsByRoute = [NSMutableDictionary dictionary];
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
        [self.protocolsByRoute removeObjectForKey:route];
        
        self.classesByRoute[route] = handlerClass;
    }
}

- (void)registerHandler:(id <DPLRouteHandlerProtocol>)handler forRoute:(NSString *)route {
    
    if (handler && [route length]) {
        [self.routes addObject:route];
        [self.blocksByRoute removeObjectForKey:route];
        [self.classesByRoute removeObjectForKey:route];
        
        self.protocolsByRoute[route] = handler;
    }
}


- (void)registerBlock:(DPLRouteHandlerBlock)routeHandlerBlock forRoute:(NSString *)route {

    if (routeHandlerBlock && [route length]) {
        [self.routes addObject:route];
        [self.classesByRoute removeObjectForKey:route];
        [self.protocolsByRoute removeObjectForKey:route];
        
        self.blocksByRoute[route] = [routeHandlerBlock copy];
    }
}


#pragma mark - Registering Routes via Object Subscripting

- (id)objectForKeyedSubscript:(id <NSCopying>)key {

    NSString *route = (NSString *)key;
    id obj = nil;
    
    if ([route isKindOfClass:[NSString class]] && [route length]) {
        obj = self.classesByRoute[route];
        if (!obj) {
            obj = self.blocksByRoute[route];
        }
        if (!obj) {
            obj = self.protocolsByRoute[route];
        }
    }
    
    return obj;
}


- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    
    NSString *route = (NSString *)key;
    if (!([route isKindOfClass:[NSString class]] && [route length])) {
        return;
    }
    
    if (!obj) {
        [self.routes removeObject:route];
        [self.classesByRoute removeObjectForKey:route];
        [self.blocksByRoute removeObjectForKey:route];
        [self.protocolsByRoute removeObjectForKey:route];
    }
    else if ([obj isKindOfClass:NSClassFromString(@"NSBlock")]) {
        [self registerBlock:obj forRoute:route];
    }
    else if (class_isMetaClass(object_getClass(obj)) &&
             [obj isSubclassOfClass:[DPLRouteHandler class]]) {
        [self registerHandlerClass:obj forRoute:route];
    }
    else if ([obj conformsToProtocol:@protocol(DPLRouteHandlerProtocol)]) {
        [self registerHandler:obj forRoute:route];
    }
}


#pragma mark - Routing Deep Links

- (void)handleURL:(NSURL *)url withCompletion:(DPLRouteCompletionBlock)completionHandler; {
    self.routeCompletionHandler = completionHandler;
    if (!url) {
        return;
    }
    
    if (![self applicationCanHandleDeepLinks]) {
        [self completeRouteWithSuccess:NO error:nil];
        return;
    }

    NSError      *error;
    DPLDeepLink  *deepLink;
    __block BOOL isHandled = NO;
    for (NSString *route in self.routes) {
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:route];
        deepLink = [matcher deepLinkWithURL:url];
        if (deepLink) {
            isHandled = [self handleRoute:route withDeepLink:deepLink error:&error];
            break;
        }
    }
    
    if (!deepLink) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"The passed URL does not match a registered route.", nil) };
        error = [NSError errorWithDomain:DPLErrorDomain code:DPLRouteNotFoundError userInfo:userInfo];
    }
    
    [self completeRouteWithSuccess:isHandled error:error];
}

- (BOOL)handleRoute:(id<DPLRouteHandlerProtocol>)routeHandler deepLink:(DPLDeepLink*)deepLink error:(NSError *__autoreleasing *)error {

    if ([routeHandler respondsToSelector:@selector(shouldHandleDeepLink:)]) {
        if (![routeHandler shouldHandleDeepLink:deepLink]) {
            return NO;
        }
    }

    UIViewController *presentingViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([routeHandler respondsToSelector:@selector(viewControllerForPresentingDeepLink:)]) {
        presentingViewController = [routeHandler viewControllerForPresentingDeepLink:deepLink];
    }

    UIViewController <DPLTargetViewController> *targetViewController = nil;
    if ([routeHandler respondsToSelector:@selector(targetViewController:)]) {
        targetViewController = [routeHandler targetViewController:deepLink];
    }
    
    if (targetViewController) {
        [targetViewController configureWithDeepLink:deepLink];
        
        if ([routeHandler respondsToSelector:@selector(presentTargetViewController:inViewController:deepLink:)]) {
            [routeHandler presentTargetViewController:targetViewController inViewController:presentingViewController deepLink:deepLink];
        }
        else {
            
            BOOL preferModalPresentation = NO;
            if ([routeHandler respondsToSelector:@selector(preferModalPresentation:)]) {
                preferModalPresentation = [routeHandler preferModalPresentation:deepLink];
            }
            
            if (preferModalPresentation ||
                ![presentingViewController isKindOfClass:[UINavigationController class]]) {
                
                [presentingViewController presentViewController:targetViewController animated:NO completion:NULL];
            }
            else if ([presentingViewController isKindOfClass:[UINavigationController class]]) {
                
                UINavigationController * navigationViewController = (UINavigationController*)presentingViewController;
                [navigationViewController placeTargetViewController:targetViewController];
            }
        }
    }
    else {
        
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"The matched route handler does not specify a target view controller.", nil)};
        
        if (error) {
            *error = [NSError errorWithDomain:DPLErrorDomain code:DPLRouteHandlerTargetNotSpecifiedError userInfo:userInfo];
        }
        
        return NO;
    }

    return YES;
}

- (BOOL)handleRoute:(NSString *)route withDeepLink:(DPLDeepLink *)deepLink error:(NSError *__autoreleasing *)error {
    id handler = self[route];
    
    if ([handler isKindOfClass:NSClassFromString(@"NSBlock")]) {
        DPLRouteHandlerBlock routeHandlerBlock = handler;
        routeHandlerBlock(deepLink);
    }
    else if ([handler conformsToProtocol:@protocol(DPLRouteHandlerProtocol)]) {
        
        id<DPLRouteHandlerProtocol> routeHandler = handler;
        return [self handleRoute:routeHandler
                        deepLink:deepLink
                           error:error];
    }
    else if (class_isMetaClass(object_getClass(handler)) &&
             [handler isSubclassOfClass:[DPLRouteHandler class]]) {
        
        id<DPLRouteHandlerProtocol> routeHandler = [[handler alloc] init];
        return [self handleRoute:routeHandler
                        deepLink:deepLink
                            error:error];
    }
    
    return YES;
}

- (void)completeRouteWithSuccess:(BOOL)handled error:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.routeCompletionHandler) {
            self.routeCompletionHandler(handled, error);
        }
    });
}

@end
