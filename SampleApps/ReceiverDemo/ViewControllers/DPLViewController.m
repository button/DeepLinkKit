#import "DPLViewController.h"
#import <DeepLinkSDK/DPLDeepLink.h>

@implementation DPLViewController

- (void)configureWithDeepLink:(DPLDeepLink *)deepLink {
    NSDictionary *colors = deepLink.appLinkData[DPLAppLinkExtrasKey];
    
    if ([colors count] == 3) {
        UIColor *color = [UIColor colorWithRed:[colors[@"red"]   floatValue]
                                         green:[colors[@"green"] floatValue]
                                          blue:[colors[@"blue"]  floatValue]
                                         alpha:1.0];
        
        self.view.backgroundColor = color;
    }
}

@end
