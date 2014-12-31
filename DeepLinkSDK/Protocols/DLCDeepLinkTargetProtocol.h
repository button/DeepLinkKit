#import <UIKit/UIKit.h>

@class DLCDeepLink;

@protocol DLCDeepLinkTarget <NSObject>

- (void)configureWithDeepLink:(DLCDeepLink *)deepLink;

@end
