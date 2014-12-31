#import "BTNViewController.h"
#import <DeepLinkSDK/BTNDeepLink.h>

@implementation BTNViewController

- (void)configureWithDeepLink:(BTNDeepLink *)deepLink {
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
