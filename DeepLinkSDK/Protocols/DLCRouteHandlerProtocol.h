#import <UIKit/UIKit.h>
#import "DLCTargetViewControllerProtocol.h"

@class DLCDeepLink;

@protocol DLCRouteHandler <NSObject>

/**
 Indicates whether your application is in a state to handle deep links.
 @return YES if your app can handle deep links, otherwise NO.
 */
+ (BOOL)canHandleDeepLinks;


/**
 Indicates whether the deep link should be handled.
 @param deepLink A resolved deep link.
 @return YES to proceed in handling the deep link, otherwise NO.
 */
- (BOOL)shouldHandleDeepLink:(DLCDeepLink *)deepLink;


/**
 Indicates the view controller that will display the deep link.
 @return A view controller to be presented.
 */
- (UIViewController <DLCTargetViewController> *)targetViewController;


@optional

/**
 Specifies the view controller from which to present a `targetViewController'.
 @param deepLink A resolved deep link.
 @return A view controller for presenting a deep link target view controller.
 */
- (UIViewController *)viewControllerForPresentingDeepLink:(DLCDeepLink *)deepLink;

@end
