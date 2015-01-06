#import <UIKit/UIKit.h>

@class DLCDeepLink;

@protocol DLCTargetViewController <NSObject>

- (void)configureWithDeepLink:(DLCDeepLink *)deepLink;

@end

