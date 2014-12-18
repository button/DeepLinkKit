#import "Specta.h"
#import "BTNDeepLinkManager.h"
#import "BTNDeepLink.h"
#import "NSString+BTNJSON.h"
#import "NSString+BTNQuery.h"

SpecBegin(BTNDeepLinkManager)

NSDictionary *payload = @{ BTNDeepLinkTargetURLKey:       @"http://dlc.button.com/ride/book/1234?partner=uber",
                           BTNDeepLinkReferrerURLKey:     @"http://derp",
                           BTNDeepLinkReferrerAppNameKey: @"derp",
                           BTNDeepLinkExtrasKey:          @{ @"foo": @"bar" }};

NSString *payloadString = [[NSString BTN_stringWithJSONObject:payload] BTN_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
NSString *URLString     = [NSString stringWithFormat:@"uber://deeplink?al_applink_data=%@", payloadString];
NSURL    *deepLinkURL   = [NSURL URLWithString:URLString ];

describe(@"Initialization", ^{
    
    it(@"returns a deep link manager instance", ^{
        BTNDeepLinkManager *manager = [[BTNDeepLinkManager alloc] init];
        expect(manager).toNot.beNil();
    });
});

describe(@"Handling Deep Links", ^{
    
    it(@"calls completion after handling a deep link", ^{
        waitUntil(^(DoneCallback done) {
            BTNDeepLinkManager *manager = [[BTNDeepLinkManager alloc] init];
            [manager handleDeepLink:deepLinkURL completionHandler:^(BOOL displayed, NSError *error) {
                expect(displayed).to.beTruthy();
                expect(error).to.beNil();
                done();
            }];
        });
    });
    
    it(@"calls completion with an error when an error occurs", ^{
        waitUntil(^(DoneCallback done) {
            BTNDeepLinkManager *manager = [[BTNDeepLinkManager alloc] init];
            [manager handleDeepLink:[NSURL URLWithString:@"derp\\"] completionHandler:^(BOOL displayed, NSError *error) {
                expect(displayed).to.beFalsy();
                expect(error).toNot.beNil();
                done();
            }];
        });
    });
});

SpecEnd
