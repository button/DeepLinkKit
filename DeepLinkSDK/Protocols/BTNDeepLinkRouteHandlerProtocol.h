#import <UIKit/UIKit.h>
#import "BTNDeepLinkTargetProtocol.h"

@class BTNDeepLink;

@protocol BTNDeepLinkRouteHandler <NSObject>


+ (BOOL)canHandleDeepLink:(BTNDeepLink *)deepLink;

/**
 Indicates whether the deep link should be displayed.
 @param deepLink A resolved deep link.
 @return YES if your application is in a state that can handle the passed deep link, otherwise NO.
 */
- (BOOL)shouldDisplayDeepLink:(BTNDeepLink *)deepLink;


- (id <BTNDeepLinkTarget>)targetViewController;

@optional

- (UIViewController *)viewControllerForPresentingDeepLink:(BTNDeepLink *)deepLink;

@end
