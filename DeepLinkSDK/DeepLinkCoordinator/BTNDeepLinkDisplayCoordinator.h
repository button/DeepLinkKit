#import <UIKit/UIKit.h>

@class BTNDeepLink;

@interface BTNDeepLinkDisplayCoordinator : NSObject

/**
 Indicates whether your application is in a state to handle deep links. Default is YES.
 @return YES if your app can handle deep links, otherwise NO.
 @see BTNDeepLinkRouteHandler
 */
- (BOOL)canHandleDeepLinks;


/**
 Indicates whether the deep link should be handled. Default is YES.
 @param deepLink A resolved deep link.
 @return YES to proceed in handling the deep link, otherwise NO.
 @see BTNDeepLinkRouteHandler
 */
- (BOOL)shouldHandleDeepLink:(BTNDeepLink *)deepLink;


/**
 Returns the default view controller for use in presenting target view controllers specified your route handler class.
 @discussion By default, the presenting view controller is the root view controller of your application's key window.
 You can subclass and override this method to return your own default view controller. Alternatively, you can specify
 the presenting view controller on a per-route basis by implementing `viewControllerForPresentingDeepLink:' in your 
 route handler class.
 */
- (UIViewController *)defaultPresentingViewController;

@end
