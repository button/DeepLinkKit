@import UIKit;

@interface UINavigationController (DPLRouting)

/**
 Places a view controller in the receivers view controller stack.
 @param targetViewController The view controller to be placed in/on to the stack.
 @note The `targetViewController' is pushed or inserted into the stack replacing any pre-existing instances of the same class. If the `targetViewController' instance is already in the stack, it will become the `topViewController'.
 */
- (void)DPL_placeTargetViewController:(UIViewController *)targetViewController;

@end
