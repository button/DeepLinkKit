#import "BTNDeepLinkDisplayCoordinator.h"

@implementation BTNDeepLinkDisplayCoordinator

- (BOOL)shouldDisplayDeepLink:(BTNDeepLink *)deepLink {
    return YES;
}


- (UIViewController *)defaultPresentingViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

@end
