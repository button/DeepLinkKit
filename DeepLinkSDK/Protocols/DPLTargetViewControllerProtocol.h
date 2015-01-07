#import <UIKit/UIKit.h>

@class DPLDeepLink;

@protocol DPLTargetViewController <NSObject>

- (void)configureWithDeepLink:(DPLDeepLink *)deepLink;

@end

