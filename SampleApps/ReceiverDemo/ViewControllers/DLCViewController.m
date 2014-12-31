#import "DLCViewController.h"
#import <DeepLinkSDK/DLCDeepLink.h>

@implementation DLCViewController

- (void)configureWithDeepLink:(DLCDeepLink *)deepLink {
    NSDictionary *colors = deepLink.appLinkData[DLCAppLinkExtrasKey];
    
    if ([colors count] == 3) {
        UIColor *color = [UIColor colorWithRed:[colors[@"red"]   floatValue]
                                         green:[colors[@"green"] floatValue]
                                          blue:[colors[@"blue"]  floatValue]
                                         alpha:1.0];
        
        self.view.backgroundColor = color;
    }
}

@end
