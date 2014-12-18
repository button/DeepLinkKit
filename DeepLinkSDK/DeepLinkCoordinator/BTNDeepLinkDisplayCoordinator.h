#import <UIKit/UIKit.h>

@class BTNDeepLink;

@interface BTNDeepLinkDisplayCoordinator : NSObject

- (BOOL)shouldDisplayDeepLink:(BTNDeepLink *)deepLink;

/**
 Returns the default view controller for use in presenting target view controllers specified your route handler class.
 @discussion By default, the presenting view controller is the root view controller of your application's key window.
 You can subclass and override this method to return your own default view controller. Alternatively, you can specify
 the presenting view controller on a per-route basis by implementing `viewControllerForPresentingDeepLink:' in your 
 route handler class.
 */
- (UIViewController *)defaultPresentingViewController;

@end
