#import "BTNDeepLinkManager.h"
#import "BTNDeepLinkRouter.h"
#import "BTNDeepLinkDisplayCoordinator.h"
#import "BTNDeepLink.h"
#import "BTNDeepLinkRouteMatcher.h"
#import "NSString+BTNTrim.h"
#import <objc/runtime.h>

@interface BTNDeepLinkManager ()

@property (nonatomic, readonly) BTNDeepLinkRouter *router;
@property (nonatomic, copy)     BTNDeepLinkCompletionHandler completionHandler;

@end

@implementation BTNDeepLinkManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _router             = [[BTNDeepLinkRouter alloc] init];
        _displayCoordinator = [[BTNDeepLinkDisplayCoordinator alloc] init];
    }
    return self;
}


- (void)handleDeepLink:(NSURL *)url completionHandler:(BTNDeepLinkCompletionHandler)completionHandler {
    
    if (![self.displayCoordinator canHandleDeepLinks]) {
        if (completionHandler) {
            completionHandler(NO, nil);
        }
        return;
    }
    
    [BTNDeepLink resolveURL:url completionHandler:^(BTNDeepLink *deepLink, NSError *error) {
        if (error) {
            if (completionHandler) {
                completionHandler(!!deepLink, error);
            }
            return;
        }
        
        self.completionHandler = completionHandler;
        [self handleDeepLink:deepLink];
    }];
}


- (void)handleDeepLink:(BTNDeepLink *)link {
 
    if (![self.displayCoordinator shouldHandleDeepLink:link]) {
        if (self.completionHandler) {
            self.completionHandler(NO, nil);
            return;
        }
    }
    
    id obj = nil;
    for (NSString *route in self.router.routes) {
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:route];
        if ([matcher matchesPath:[link.targetURL path]]) {
            obj = self.router[route];
            break;
        }
    }
    
    if ([obj isKindOfClass:NSClassFromString(@"NSBlock")]) {
        BTNDeepLinkRouteHandlerBlock routeHandlerBlock = obj;
        routeHandlerBlock(link);
        
        if (self.completionHandler) {
            self.completionHandler(link, nil);
        }
    }
    else if (class_isMetaClass(object_getClass(obj)) && [obj conformsToProtocol:@protocol(BTNDeepLinkRouteHandler)]) {
        id <BTNDeepLinkRouteHandler> routeHander = [[obj alloc] init];
        [self navigateToDeepLink:link withHandler:routeHander];
    }
}


- (void)navigateToDeepLink:(BTNDeepLink *)link withHandler:(id <BTNDeepLinkRouteHandler>)routeHandler {

    if ([routeHandler shouldHandleDeepLink:link]) {

        UIViewController *presenter = [self.displayCoordinator defaultPresentingViewController];
        if ([routeHandler respondsToSelector:@selector(viewControllerForPresentingDeepLink:)]) {
            presenter = [routeHandler viewControllerForPresentingDeepLink:link];
        }
        
        UIViewController *targetViewController = (UIViewController *)[routeHandler targetViewController];
        if (!targetViewController) {
#pragma message "error here for no target returned"
            return;
        }
        
        if ([presenter isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)presenter pushViewController:targetViewController animated:YES];
        }
        else {
            [presenter presentViewController:targetViewController animated:YES completion:NULL];
        }
    }
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.router;
}

@end
