#import "Specta.h"
#import "DPLDeepLink.h"
#import "DPLDeepLink_Private.h"
#import "DPLMutableDeepLink.h"
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
    
});


describe(@"Copying", ^{
    
    NSURL *url = [NSURL URLWithString:@"dpl://dpl.io/ride/abc123?partner=uber"];
    
    it(@"returns an immutable deep link via copy", ^{
        DPLDeepLink *link1 = [[DPLDeepLink alloc] initWithURL:url];
        DPLDeepLink *link2 = [link1 copy];
        
        expect(link2).toNot.beNil();
        expect(link1.URL).to.equal(link2.URL);
        expect(link1.queryParameters).to.equal(link2.queryParameters);
        expect(link1.callbackURL).to.equal(link2.callbackURL);
    });
    
    it(@"returns a mutable deep link via mutable copy", ^{
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:url];
        DPLMutableDeepLink *mutableLink = [link mutableCopy];
        
        expect(mutableLink).toNot.beNil();
        expect(mutableLink.scheme).to.equal(@"dpl");
        expect(mutableLink.host).to.equal(@"dpl.io");
        expect(mutableLink.path).to.equal(@"/ride/abc123");
        expect(mutableLink.queryParameters).to.equal(link.queryParameters);
        expect(mutableLink.URL).to.equal(link.URL);
    });
});

SpecEnd
