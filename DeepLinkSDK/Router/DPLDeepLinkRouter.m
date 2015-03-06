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

- (void)handleURL:(NSURL *)url withCompletion:(DPLRouteCompletionBlock)completionHandler {

    if (!url) {
        [self completeRouteWithSuccess:completionHandler handled:NO targetViewController:nil error:nil];
        return;
    }
    
    if (![self applicationCanHandleDeepLinks]) {
        [self completeRouteWithSuccess:completionHandler handled:NO targetViewController:nil error:nil];
        return;
    }

    NSError      *error;
    DPLDeepLink  *deepLink;
    __block BOOL isHandled = NO;
    for (NSString *route in self.routes) {
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:route];
        deepLink = [matcher deepLinkWithURL:url];
        if (deepLink) {
            isHandled = [self handleRoute:route withDeepLink:deepLink error:&error completionHandler:completionHandler];
            break;
        }
    }
    
    if (!deepLink) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"The passed URL does not match a registered route.", nil) };
        error = [NSError errorWithDomain:DPLErrorDomain code:DPLRouteNotFoundError userInfo:userInfo];
    }
    
    // if it's handled, handleRoute will call completeRouteWithSuccess
    if (!isHandled) {
        [self completeRouteWithSuccess:completionHandler
                               handled:isHandled
                  targetViewController:nil error:error];
    }
}

- (BOOL)handleRoute:(id<DPLRouteHandlerProtocol>)routeHandler deepLink:(DPLDeepLink*)deepLink error:(NSError *__autoreleasing *)error completionHandler:(DPLRouteCompletionBlock)completionHandler {

    if ([routeHandler respondsToSelector:@selector(shouldHandleDeepLink:)]) {
        if (![routeHandler shouldHandleDeepLink:deepLink]) {
            return NO;
        }
    }

    UIViewController *presentingViewController = nil;
    if ([routeHandler respondsToSelector:@selector(URLForPresentingDeepLink:)]) {
    
        NSURL * presentingLink = [routeHandler URLForPresentingDeepLink:deepLink];
        if (presentingLink != nil) {
            
            // async
            [self handleURL:presentingLink withCompletion:^(BOOL handled, NSError *handleURLError, UIViewController<DPLTargetViewController> *targetViewController) {
                
                if (handleURLError) {
                    
                    [self completeRouteWithSuccess:completionHandler handled:NO targetViewController:targetViewController error:handleURLError];
              } else {
                  
                  NSError *presentError;
                BOOL handled = [self presentRoute:routeHandler
            presentingViewController:targetViewController
                            deepLink:deepLink
                               error:&presentError];
                  
                  [self completeRouteWithSuccess:completionHandler handled:handled targetViewController:targetViewController error:presentError];
              }
                
                
            }];
            
            return  YES;
        }
    }
    
    return [self presentRoute:routeHandler
     presentingViewController:presentingViewController
                     deepLink:deepLink
                        error:error];
}

- (BOOL)presentRoute:(id<DPLRouteHandlerProtocol>)routeHandler
 presentingViewController:(UIViewController*)presentingViewController
                 deepLink:(DPLDeepLink*)deepLink
                    error:(NSError *__autoreleasing *)error {
    
     if (presentingViewController == nil) {
     
         if ([routeHandler respondsToSelector:@selector(viewControllerForPresentingDeepLink:)]) {
             
             presentingViewController = [routeHandler viewControllerForPresentingDeepLink:deepLink];
         }
         else {
             presentingViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
         }
     }
     
     if ([routeHandler respondsToSelector:@selector(targetViewController:completionHandler:)]) {
         
         [routeHandler targetViewController:deepLink completionHandler:^(UIViewController<DPLTargetViewController> *targetViewController) {
         
             [self presentTargetViewController:routeHandler targetViewController:targetViewController inViewController:presentingViewController deepLink:deepLink];
         }];
     
         return YES;
     }
     
     UIViewController <DPLTargetViewController> *targetViewController = nil;
     if ([routeHandler respondsToSelector:@selector(targetViewController:)]) {
         targetViewController = [routeHandler targetViewController:deepLink];
     }
     
     if (targetViewController) {
         [self presentTargetViewController:routeHandler
         targetViewController:targetViewController
         inViewController:presentingViewController
         deepLink:deepLink];
     } else {
         NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: NSLocalizedString(@"The matched route handler does not specify a target view controller.", nil)};
         
         if (error) {
             *error = [NSError errorWithDomain:DPLErrorDomain code:DPLRouteHandlerTargetNotSpecifiedError userInfo:userInfo];
         }
         
         return NO;
     }
     
     return YES;
}

- (BOOL)handleRoute:(NSString *)route withDeepLink:(DPLDeepLink *)deepLink error:(NSError *__autoreleasing *)error completionHandler:(DPLRouteCompletionBlock)completionHandler {
    id handler = self[route];
    
    if ([handler isKindOfClass:NSClassFromString(@"NSBlock")]) {
        DPLRouteHandlerBlock routeHandlerBlock = handler;
        routeHandlerBlock(deepLink);
    }
    else if (class_isMetaClass(object_getClass(handler)) &&
             [handler isSubclassOfClass:[DPLRouteHandler class]]) {
        
        id<DPLRouteHandlerProtocol> routeHandler = [[handler alloc] init];
        return [self handleRoute:routeHandler
                        deepLink:deepLink
                            error:error
               completionHandler:completionHandler];
    }
    else if ([handler conformsToProtocol:@protocol(DPLRouteHandlerProtocol)]) {
        
        id<DPLRouteHandlerProtocol> routeHandler = handler;
        return [self handleRoute:routeHandler
                        deepLink:deepLink
                           error:error
               completionHandler:completionHandler];
    }

    return YES;
}

                  
- (void)completeRouteWithSuccess:(DPLRouteCompletionBlock)handler
                         handled:(BOOL)handled
            targetViewController:(UIViewController<DPLTargetViewController>*)targetViewController
                           error:(NSError *)error {

    if (!handler) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        handler(handled, error, targetViewController);
    });
}
    
- (void)presentTargetViewController:(id<DPLRouteHandlerProtocol>)routeHandler
               targetViewController:(UIViewController <DPLTargetViewController> *)targetViewController
                   inViewController:(UIViewController *)presentingViewController
                           deepLink:(DPLDeepLink *)deepLink
{

    if (targetViewController) {
        if ([targetViewController respondsToSelector:@selector(configureWithDeepLink:)]) {
            [targetViewController configureWithDeepLink:deepLink];
        }
        
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
}

@end
