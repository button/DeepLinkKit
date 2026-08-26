@import UIKit;

@class DPLDeepLink;

@protocol DPLTargetViewController <NSObject>

/**
 Implement this method on conforming view controllers to configure it with data
 provided by the passed deep link.
 @note Depending on your view controller implementation, its views may not be instantiated when
 this method gets called. In that case, you might store the relevant data and configure its views
 in `-[UIViewController viewDidLoad]'.
 */
- (void)configureWithDeepLink:(DPLDeepLink *)deepLink;

@end

