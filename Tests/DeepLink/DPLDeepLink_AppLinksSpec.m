#import "DPLDeepLink_Private.h"
#import "DPLMutableDeepLink.h"
#import "DPLMutableDeepLink+AppLinks.h"
@import DeepLinkKit;
@import DeepLinkKit.AppLinks;

SpecBegin(DPLDeepLink_AppLinks)

DPLMutableDeepLink *appLink = [[DPLMutableDeepLink alloc] initWithString:@"dpl://applinks"];
appLink.targetURL           = [NSURL URLWithString:@"http://dpl.io/say"];
appLink.extras[@"hello"]    = @"world";
appLink.userAgent           = @"DPL 1.0";
appLink.referrerTargetURL   = [NSURL URLWithString:@"http://dpl.io/say"];
appLink.referrerURL         = [NSURL URLWithString:@"btn://dpl.io/say"];
appLink.referrerAppName     = @"Deep Link";

NSURL *appLinkURL = appLink.URL;

describe(@"App Links Properties", ^{
    
    it(@"return values when the deep link is an App Link", ^{
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:appLinkURL];
        expect(link.URL)      .to.equal(appLinkURL);
        expect(link.targetURL).to.equal(appLink.targetURL);
        expect(link.extras)   .to.equal(appLink.extras);
        expect(link.version)  .to.equal(appLink.version);
        expect(link.userAgent).to.equal(appLink.userAgent);
        
        expect(link.referrerTargetURL).to.equal(appLink.referrerTargetURL);
        expect(link.referrerURL)      .to.equal(appLink.referrerURL);
        expect(link.referrerAppName)  .to.equal(appLink.referrerAppName);
        
        expect(link.callbackURL).to.equal(appLink.callbackURL);
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
