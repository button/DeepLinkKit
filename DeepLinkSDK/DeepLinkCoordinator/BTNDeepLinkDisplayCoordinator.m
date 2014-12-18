#import "BTNDeepLinkDisplayCoordinator.h"

@implementation BTNDeepLinkDisplayCoordinator

- (BOOL)canHandleDeepLinks {
    return YES;
}


- (BOOL)shouldHandleDeepLink:(BTNDeepLink *)deepLink {
    return YES;
}


- (UIViewController *)defaultPresentingViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

@end
