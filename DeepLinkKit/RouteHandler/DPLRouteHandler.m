#import "DPLRouteHandler.h"
#import "UINavigationController+DPLRouting.h"

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


- (void)presentTargetViewController:(UIViewController <DPLTargetViewController> *)targetViewController
                   inViewController:(UIViewController *)presentingViewController {
    
    if ([self preferModalPresentation] ||
        ![presentingViewController isKindOfClass:[UINavigationController class]]) {
        
        [presentingViewController presentViewController:targetViewController animated:NO completion:NULL];
    }
    else if ([presentingViewController isKindOfClass:[UINavigationController class]]) {
        
        [((UINavigationController *)presentingViewController) DPL_placeTargetViewController:targetViewController];
    }
}

@end
