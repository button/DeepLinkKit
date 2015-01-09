#import "Specta.h"
#import "DPLDeepLink_Private.h"
#import "DPLDeepLink+AppLinks.h"
#import "NSString+DPLJSON.h"
#import "NSString+DPLQuery.h"

SpecBegin(DPLDeepLink_AppLinks)

NSDictionary *referrer = @{ DPLAppLinksReferrerTargetURLKey: @"http://dpl.io/say",
                            DPLAppLinksReferrerURLKey:       @"btn://dpl.io/say",
                            DPLAppLinksReferrerAppNameKey:   @"Button" };

NSDictionary *payload  = @{ DPLAppLinksTargetURLKey: @"http://dpl.io/say",
                            DPLAppLinksExtrasKey:    @{ @"word": @"hello" },
                            DPLAppLinksVersionKey:   @"1.0",
                            DPLAppLinksUserAgentKey: @"DPL 1.0",
                            DPLAppLinksReferrerAppLinkKey: referrer };

NSString *payloadString = [[NSString DPL_stringWithJSONObject:payload] DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSString *URLString = [NSString stringWithFormat:@"dpl://deeplink?al_applink_data=%@", payloadString];
NSURL *appLinkURL   = [NSURL URLWithString:URLString];

describe(@"App Links Properties", ^{
    
    it(@"return values when the deep link is an App Link", ^{
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:appLinkURL];
        expect(link.targetURL.absoluteString).to.equal(payload[DPLAppLinksTargetURLKey]);
        expect(link.extras).to.equal(payload[DPLAppLinksExtrasKey]);
        expect(link.version).to.equal(payload[DPLAppLinksVersionKey]);
        expect(link.userAgent).to.equal(payload[DPLAppLinksUserAgentKey]);
        
        expect(link.referrerTargetURL.absoluteString).to.equal(referrer[DPLAppLinksReferrerTargetURLKey]);
        expect(link.referrerURL.absoluteString).to.equal(referrer[DPLAppLinksReferrerURLKey]);
        expect(link.referrerAppName).to.equal(referrer[DPLAppLinksReferrerAppNameKey]);
        
        expect(link.callbackURL.absoluteString).to.equal(referrer[DPLAppLinksReferrerURLKey]);
    });
    
    it(@"return nil when the deep link is NOT an App Link", ^{
        NSURL *url = [NSURL URLWithString:@"dpl://dpl.io/say/:word?foo=bar&baz=qux"];
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:url];
        expect(link.targetURL).to.beNil();
        expect(link.extras)   .to.beNil();
        expect(link.version)  .to.beNil();
        expect(link.userAgent).to.beNil();
        
        expect(link.referrerTargetURL).to.beNil();
        expect(link.referrerURL)      .to.beNil();
        expect(link.referrerAppName)  .to.beNil();
    });
});

SpecEnd
