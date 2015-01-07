#import "Specta.h"
#import "DPLDeepLink.h"
#import "DPLDeepLink_Private.h"
#import "NSString+DPLJSON.h"
#import "NSString+DPLQuery.h"

SpecBegin(DPLDeepLink)

NSDictionary *payload = @{ DPLAppLinkTargetURLKey: @"http://DPL.button.com/ride/book/abc123?partner=uber" };

NSString *payloadString = [[NSString DPL_stringWithJSONObject:payload] DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSString *URLString = [NSString stringWithFormat:@"DPL://deeplink?al_applink_data=%@", payloadString];
NSURL *appLinkURL = [NSURL URLWithString:URLString];

describe(@"Initialization", ^{

    it(@"returns a deep link", ^{
        
        NSURL *url = [NSURL URLWithString:@"DPL://DPL.com/ride/book/abc123?partner=uber"];
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:url];
        expect(link.URL).to.equal(url);
        expect(link.queryParameters).to.equal(@{ @"partner": @"uber"});
        expect(link.appLinkData).to.beNil();
    });
    
    it(@"returns a deep link in App Link format", ^{
        
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:appLinkURL];
        expect([link.URL absoluteString]).to.equal(payload[DPLAppLinkTargetURLKey]);
        expect(link.queryParameters).to.equal(@{ @"partner": @"uber"});
        expect(link.appLinkData).to.equal(payload);
    });
});

SpecEnd
