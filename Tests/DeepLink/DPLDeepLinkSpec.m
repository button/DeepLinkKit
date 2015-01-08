#import "Specta.h"
#import "DPLDeepLink.h"
#import "DPLDeepLink_Private.h"


SpecBegin(DPLDeepLink)

describe(@"Initialization", ^{

    it(@"returns a deep link when passed a URL", ^{
        NSURL *url = [NSURL URLWithString:@"dpl://dpl.io/ride/book/abc123?partner=uber"];
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:url];
        expect(link.URL).to.equal(url);
        expect(link.queryParameters).to.equal(@{ @"partner": @"uber" });
    });
    
    it(@"returns nil when passed nil", ^{
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:nil];
        expect(link).to.beNil();
    });
});

SpecEnd
