#import "BTNViewController.h"
#import "NSString+BTNQuery.h"
#import "NSString+BTNJSON.h"
#import "BTNDeepLink.h"

@implementation BTNViewController

- (IBAction)deepLinkAction:(UIButton *)sender {
    
    NSDictionary *payload = @{ BTNDeepLinkTargetURLKey:       @"http://dlc.button.com/table/book/1234?partner=uber",
                               BTNDeepLinkReferrerURLKey:     @"http://derp",
                               BTNDeepLinkReferrerAppNameKey: @"derp",
                               BTNDeepLinkExtrasKey:          @{ @"restaurant": @"Charlie Bird", @"time": @"8:30 PM" }};
    
    NSString *payloadString = [[NSString BTN_stringWithJSONObject:payload] BTN_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *URLString     = [NSString stringWithFormat:@"dlc://deeplink?al_applink_data=%@", payloadString];
    NSURL    *deepLinkURL   = [NSURL URLWithString:URLString];
    
    [[UIApplication sharedApplication] openURL:deepLinkURL];
}

@end
