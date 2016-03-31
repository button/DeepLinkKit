@import UIKit;
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
 @return A view controller for presenting a target view controller.
 */
- (UIViewController *)viewControllerForPresentingDeepLink:(DPLDeepLink *)deepLink;


/**
 Displays the target view controller via the presenting view controller.
 @note This method should only be overridden if you're looking for maximum flexibility in
 presenting your view controller. 
 
 @discussion By default, the `targetViewController' is presented modally when the
 presenting view controller is anything but a UINavigationController. If the presenting view controller 
 is a UINavigationController and `-preferModalPresentation' returns NO, the `targetViewController' is 
 pushed or placed into the stack replacing any pre-existing instances of the same class. If the `targetViewController' instance is already in the stack, it will become the `topViewController'.
 
 @param targetViewController A view controller conforming to the `DPLTargetViewController' protocol.
 @param presentingViewController A view controller for presenting a target view controller.
 */
- (void)presentTargetViewController:(UIViewController <DPLTargetViewController> *)targetViewController
                   inViewController:(UIViewController *)presentingViewController;

@end
