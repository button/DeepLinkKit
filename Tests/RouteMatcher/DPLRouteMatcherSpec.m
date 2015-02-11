#import "Specta.h"
#import "DPLRouteMatcher.h"
#import "DPLDeepLink.h"

NSURL *URLWithPath(NSString *path) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"dpl://dpl.com%@", path]];
}

SpecBegin(DPLRouteMatcher)


describe(@"Matching Routes", ^{
    
    it(@"returns a deep link when a URL matches a route", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/table/book"];
        NSURL *url = URLWithPath(@"/table/book");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"returns a deep link when a URL matches a host", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"dpl.com"];
        NSURL *url = URLWithPath(@"");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"does NOT return a deep link when a host does NOT match the URL host", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"dpl2.com"];
        NSURL *url = URLWithPath(@"");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"does NOT return a deep link when a host does NOT match and path does match", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"dpl2.com/table/:id"];
        NSURL *url = URLWithPath(@"/table/abc123");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"returns a deep link when a URL matches a host and path", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"dpl.com/table"];
        NSURL *url = URLWithPath(@"/table");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"does NOT return a deep link when a host matches and a path does NOT match", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"dpl.com/ride"];
        NSURL *url = URLWithPath(@"/table");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"returns a deep link when a URL matches a parameterized route", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"dpl.com/table/book/:id"];
        NSURL *url = URLWithPath(@"/table/book/abc123");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"does NOT return a deep link when the URL and route don't match", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/table/book"];
        NSURL *url = URLWithPath(@"/table/book/abc123");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });

    it(@"does NOT return a deep link when the URL and parameterized route dont match", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/table/book/:id"];
        NSURL *url = URLWithPath(@"/table/book");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"does NOT return a deep link when the URL path does not match the route path", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/table/book/:id"];
        NSURL *url = URLWithPath(@"/ride/book");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"returns a deep link with route parameters when a URL matches a parameterized route", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/table/book/:id/:time"];
        NSURL *url = URLWithPath(@"/table/book/abc123/1418931000");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink.routeParameters).to.equal(@{ @"id": @"abc123", @"time": @"1418931000" });
    });
    
    it(@"returns a deep link with route parameters when a URL matches a parameterized route for a specific host", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"dpl.com/table/book/:id/:time"];
        NSURL *url = URLWithPath(@"/table/book/abc123/1418931000");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink.routeParameters).to.equal(@{ @"id": @"abc123", @"time": @"1418931000" });
    });
    
    it(@"does NOT return a deep link with route parameters when a URL matches a parameterized route for a specific host", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"dpl2.com/table/book/:id/:time"];
        NSURL *url = URLWithPath(@"/table/book/abc123/1418931000");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"matches a wildcard deep link", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@".*"];
        NSURL *url = URLWithPath(@"/table/book/abc123/1418931000");
        NSURL *url2 = URLWithPath(@"/abc123");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).notTo.beNil();

        DPLDeepLink *deepLink2 = [matcher deepLinkWithURL:url2];
        expect(deepLink2).notTo.beNil();
    });
});

SpecEnd
