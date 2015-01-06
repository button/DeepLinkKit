#import "DLCDeepLinkManager.h"
#import "DLCDeepLinkRouter.h"
#import "DLCDeepLink.h"
#import "DLCDeepLinkRouteMatcher.h"
#import "NSString+DLCTrim.h"
#import <objc/runtime.h>

@interface DLCDeepLinkManager ()

@property (nonatomic, readonly) DLCDeepLinkRouter *router;


@end

@implementation DLCDeepLinkManager

- (void)navigateToDeepLink:(DLCDeepLink *)link withHandler:(id <DLCRouteHandler>)routeHandler {

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
