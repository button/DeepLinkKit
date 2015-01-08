#import <UIKit/UIKit.h>
#import "DPLTargetViewControllerProtocol.h"

@class DPLDeepLink;

/**
 A base class for handling routes. 
 
 While it's easy to just register block route handlers, some of your routes might require
 a bit more work resulting a mess of code in your block handler. Creating a `DPLRouteHandler'
 subclass helps move that complexity from route registration to a more sensible place.
 
 @note Subclasses of `DPLRouteHandler' have two rules, they MUST specify a target view controller 
 and they must conform to the `DPLTargetViewController' protocol. You can provide a view controller 
 by overriding `targetViewController'.
 
 @see DPLTargetViewController
 */
@interface DPLRouteHandler : NSObject

/**
 Indicates whether the deep link should be handled.
 @param deepLink A deep link instance.
 @return YES to proceed with handling the deep link, otherwise NO. The default is YES.
 */
- (BOOL)shouldHandleDeepLink:(DPLDeepLink *)deepLink;


/**
 If `viewControllerForPresentingDeepLink:' returns a `UINavigationController', the default behavior
 is to place the `targetViewController' in the navigation stack. If you prefer to always present
 the target view controller modally, override this method and return YES. The default is NO.
 */
- (BOOL)preferModalPresentation;


/**
 The view controller that will be presented as a result of the deep link.
 @return A view controller conforming to the `DPLTargetViewController' protocol.
 @note Subclasses MUST override this method.
 */
- (UIViewController <DPLTargetViewController> *)targetViewController;


/**
 Specifies the view controller from which to present a `targetViewController'.
 @note The default implementation returns your application's root view controller.
 
 @param deepLink A deep link instance.
 @return A view controller for presenting a deep link target view controller.
 */
- (UIViewController *)viewControllerForPresentingDeepLink:(DPLDeepLink *)deepLink;

@end
