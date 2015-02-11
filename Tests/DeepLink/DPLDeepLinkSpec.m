#import "Specta.h"
#import "DPLDeepLink.h"
#import "DPLDeepLink_Private.h"
#import "NSString+DPLQuery.h"


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
    
    it(@"has a callback url when a dpl_callback_url is present", ^{
        
        NSString *callBackURLString = @"btn://dpl.io/say/hi";
        
        NSString *URLString = [NSString stringWithFormat:@"dpl://dpl.io/say/hello?dpl_callback_url=%@",
                               [callBackURLString DPL_stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:[NSURL URLWithString:URLString]];
        expect([link.callbackURL absoluteString]).to.equal(callBackURLString);
    });
    
    it(@"should favor route parameters over query parameters for indexed subscripting", ^{
        NSURL *url = [NSURL URLWithString:@"dpl://dpl.io/ride/book/abc123?partner=uber"];
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:url];
        link.routeParameters = @{
                                 @"partner": @"not-uber"
                                 };
        expect(link[@"partner"]).to.equal(@"not-uber");
    });
});

SpecEnd
