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
    
    it(@"should favor route parameters over query parameters for indexed subscripting", ^{
        NSURL *url = [NSURL URLWithString:@"dpl://dpl.io/ride/book/abc123?partner=uber"];
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:url];
        link.routeParameters = @{
                                 @"partner": @"not-uber"
                                 };
        expect(link[@"partner"]).to.equal(@"not-uber");
    });
    
    it(@"preserves key only query items", ^{
        NSURL *url = [NSURL URLWithString:@"seamlessapp://menu?293147"];
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:url];
        expect(link.queryParameters[@"293147"]).to.equal(@"");
        expect(link.URL.absoluteString).to.equal(@"seamlessapp://menu?293147");
    });
});


describe(@"Copying", ^{
    
    NSURL *url = [NSURL URLWithString:@"dpl://dpl.io/ride/abc123?partner=uber"];
    
    it(@"returns an immutable deep link via copy", ^{
        DPLDeepLink *link1 = [[DPLDeepLink alloc] initWithURL:url];
        DPLDeepLink *link2 = [link1 copy];
        
        expect(link2).toNot.beNil();
        expect(link2.URL).to.equal(link1.URL);
        expect(link2.queryParameters).to.equal(link1.queryParameters);
        expect(link2.routeParameters).to.equal(link1.routeParameters);
        expect(link2.callbackURL).to.equal(link1.callbackURL);
    });
    
    it(@"immutable copy includes route parameters", ^{
        DPLDeepLink *link1 = [[DPLDeepLink alloc] initWithURL:url];
        link1.routeParameters = @{ @"type": @"ride" };
        DPLDeepLink *link2 = [link1 copy];
        expect(link2.routeParameters).to.equal(link1.routeParameters);
    });
    
    it(@"returns a mutable deep link via mutable copy", ^{
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:url];
        DPLMutableDeepLink *mutableLink = [link mutableCopy];
        
        expect(mutableLink).toNot.beNil();
        expect(mutableLink.scheme).to.equal(@"dpl");
        expect(mutableLink.host).to.equal(@"dpl.io");
        expect(mutableLink.path).to.equal(@"/ride/abc123");
        expect(mutableLink.queryParameters).to.equal(link.queryParameters);
        expect(mutableLink.routeParameters).to.equal(link.routeParameters);
        expect(mutableLink.URL).to.equal(link.URL);
    });
    
    it(@"mutable copy includes route parameters", ^{
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:url];
        link.routeParameters = @{ @"type": @"ride" };
        DPLMutableDeepLink *mutableLink = [link mutableCopy];
        expect(mutableLink.routeParameters).to.equal(link.routeParameters);
    });
});


describe(@"Equality", ^{
    
    NSURL *url1 = [NSURL URLWithString:@"dpl://dpl.io/ride/abc123?partner=uber"];
    NSURL *url2 = [NSURL URLWithString:@"dpl://dpl.io/book/def456?partner=airbnb"];
    
    it(@"two identical deeps links are equal", ^{
        DPLDeepLink *link1 = [[DPLDeepLink alloc] initWithURL:url1];
        DPLDeepLink *link2 = [[DPLDeepLink alloc] initWithURL:url1];
        
        expect(link1).to.equal(link2);
    });
    
    it(@"two different deep links are inequal", ^{
        DPLDeepLink *link1 = [[DPLDeepLink alloc] initWithURL:url1];
        DPLDeepLink *link2 = [[DPLDeepLink alloc] initWithURL:url2];
        
        expect(link1).toNot.equal(link2);
    });
    
    it(@"nil is not equal to a deep link", ^{
        DPLDeepLink *link = [[DPLDeepLink alloc] initWithURL:url1];
        
        expect(link).toNot.equal(nil);
    });
    
    it(@"an empty deep link is not equal to a deep link", ^{
        DPLDeepLink *link1 = [[DPLDeepLink alloc] initWithURL:url1];
        DPLDeepLink *link2 = [[DPLDeepLink alloc] init];
        
        expect(link1).toNot.equal(link2);
    });
    
    it(@"two empty deep links are equal", ^{
        DPLDeepLink *link1 = [[DPLDeepLink alloc] init];
        DPLDeepLink *link2 = [[DPLDeepLink alloc] init];
        
        expect(link1).to.equal(link2);
    });
});

SpecEnd
