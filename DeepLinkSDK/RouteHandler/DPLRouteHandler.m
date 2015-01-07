#import "DPLRouteHandler.h"

@implementation DPLRouteHandler

- (BOOL)shouldHandleDeepLink:(DPLDeepLink *)deepLink {
    return YES;
}


- (UIViewController <DPLTargetViewController> *)targetViewController {
    return nil;
}


- (UIViewController *)viewControllerForPresentingDeepLink:(DPLDeepLink *)deepLink {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

@end
