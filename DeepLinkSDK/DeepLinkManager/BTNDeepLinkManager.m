#import "BTNDeepLinkManager.h"
#import "BTNDeepLinkRouter.h"
#import "BTNDeepLink.h"
#import "BTNDeepLinkRouteMatcher.h"
#import "NSString+BTNTrim.h"
#import <objc/runtime.h>

@interface BTNDeepLinkManager ()

@property (nonatomic, readonly) BTNDeepLinkRouter *router;


@end

@implementation BTNDeepLinkManager

- (void)navigateToDeepLink:(BTNDeepLink *)link withHandler:(id <BTNDeepLinkRouteHandler>)routeHandler {

//    if ([routeHandler shouldHandleDeepLink:link]) {
//
//        UIViewController *presenter = [self.displayCoordinator defaultPresentingViewController];
//        if ([routeHandler respondsToSelector:@selector(viewControllerForPresentingDeepLink:)]) {
//            presenter = [routeHandler viewControllerForPresentingDeepLink:link];
//        }
//        
//        UIViewController *targetViewController = (UIViewController *)[routeHandler targetViewController];
//        if (!targetViewController) {
//#pragma message "error here for no target returned"
//            return;
//        }
//        
//        if ([presenter isKindOfClass:[UINavigationController class]]) {
//            [(UINavigationController *)presenter pushViewController:targetViewController animated:YES];
//        }
//        else {
//            [presenter presentViewController:targetViewController animated:YES completion:NULL];
//        }
//    }
}


- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.router;
}

@end
