#import "DPLRouteHandler.h"

@implementation DPLRouteHandler

- (BOOL)shouldHandleDeepLink:(DPLDeepLink *)deepLink {
    return YES;
}


- (BOOL)preferModalPresentation {
    return NO;
}


- (UIViewController <DPLTargetViewController> *)targetViewController {
    return nil;
}


- (UIViewController *)viewControllerForPresentingDeepLink:(DPLDeepLink *)deepLink {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

@end
