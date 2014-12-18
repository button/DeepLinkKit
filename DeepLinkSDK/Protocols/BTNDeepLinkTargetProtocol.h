#import <UIKit/UIKit.h>

@class BTNDeepLink;

@protocol BTNDeepLinkTarget <NSObject>

- (void)configureWithDeepLink:(BTNDeepLink *)deepLink;

@end
