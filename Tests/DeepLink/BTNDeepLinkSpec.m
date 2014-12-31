#import "Specta.h"
#import "BTNDeepLink.h"
#import "BTNDeepLink_Private.h"
#import "NSString+BTNJSON.h"
#import "NSString+BTNQuery.h"

SpecBegin(BTNDeepLink)

NSDictionary *payload = @{ DLCAppLinkTargetURLKey: @"http://dlc.button.com/ride/book/abc123?partner=uber" };

NSString *payloadString = [[NSString BTN_stringWithJSONObject:payload] BTN_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSString *URLString = [NSString stringWithFormat:@"dlc://deeplink?al_applink_data=%@", payloadString];
NSURL *appLinkURL = [NSURL URLWithString:URLString];

describe(@"Initialization", ^{

    it(@"returns a deep link", ^{
        
        NSURL *url = [NSURL URLWithString:@"dlc://dlc.com/ride/book/abc123?partner=uber"];
        BTNDeepLink *link = [[BTNDeepLink alloc] initWithURL:url];
        expect(link.URL).to.equal(url);
        expect(link.queryParameters).to.equal(@{ @"partner": @"uber"});
        expect(link.appLinkData).to.beNil();
    });
    
    it(@"returns a deep link in App Link format", ^{
        
        BTNDeepLink *link = [[BTNDeepLink alloc] initWithURL:appLinkURL];
        expect([link.URL absoluteString]).to.equal(payload[DLCAppLinkTargetURLKey]);
        expect(link.queryParameters).to.equal(@{ @"partner": @"uber"});
        expect(link.appLinkData).to.equal(payload);
    });
});

SpecEnd
