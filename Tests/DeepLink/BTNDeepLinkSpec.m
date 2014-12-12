#import "Specta.h"
#import "BTNDeepLink.h"
#import "NSString+BTNJSON.h"
#import "NSString+BTNQuery.h"

SpecBegin(BTNDeepLink)

NSDictionary *payload = @{ BTNDeepLinkTargetURLKey:       @"http://dlc.button.com/ride/book/1234?partner=uber",
                           BTNDeepLinkReferrerURLKey:     @"http://derp",
                           BTNDeepLinkReferrerAppNameKey: @"derp",
                           BTNDeepLinkExtrasKey:          @{ @"foo": @"bar" }};

NSString *payloadString = [[NSString BTN_stringWithJSONObject:payload] BTN_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSString *URLString     = [NSString stringWithFormat:@"uber://deeplink?al_applink_data=%@", payloadString];
NSURL    *deepLinkURL   = [NSURL URLWithString:URLString ];

describe(@"Resolving Deep Links", ^{

    it(@"resolves a url into a deep link instance", ^{
        waitUntil(^(DoneCallback done) {
            [BTNDeepLink resolveURL:deepLinkURL completionHandler:^(BTNDeepLink *deepLink, NSError *error) {
                expect(deepLink).toNot.beNil();
                expect([deepLink.targetURL description]).to.equal(payload[BTNDeepLinkTargetURLKey]);
                expect(deepLink.targetQueryParameters).to.equal(@{ @"partner": @"uber" });
                expect(deepLink.useCase).to.equal(@"ride");
                expect(deepLink.action).to.equal(@"book");
                expect(deepLink.objectId).to.equal(@"1234");
                expect(deepLink.incomingURL).to.equal(deepLinkURL);
                expect(deepLink.incomingQueryParameters).to.equal(@{ BTNDeepLinkPayloadKey: [NSString BTN_stringWithJSONObject:payload] });
                done();
            }];
        });
    });
    
    pending(@"more tests", ^{
        
    });
});

SpecEnd
