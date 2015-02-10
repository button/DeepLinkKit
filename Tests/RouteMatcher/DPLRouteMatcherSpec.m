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
        expect(deepLink.routeParameters).to.equal(@{});
    });
    
    it(@"returns a deep link when a URL matches a host", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"dpl.com"];
        NSURL *url = URLWithPath(@"");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).toNot.beNil();
        expect(deepLink.routeParameters).to.equal(@{});
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
        expect(deepLink.routeParameters).to.equal(@{});

        DPLDeepLink *deepLink2 = [matcher deepLinkWithURL:url2];
        expect(deepLink2).notTo.beNil();
        expect(deepLink2.routeParameters).to.equal(@{});
    });
    
    it(@"matches URLs with commas", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"TenDay/:weird_comma_path_thing"];
        NSURL *url = [NSURL URLWithString:@"twcweather://TenDay/33.89,-84.46?aw_campaign=com.weather.TWC.TWCWidget"];
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink.routeParameters[@"weird_comma_path_thing"]).to.equal(@"33.89,-84.46");
        expect(deepLink).notTo.beNil();
    });
    
    it(@"returns a deep link with route parameters when a URL matches a parameterized regex route", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/table/:table([a-zA-Z]+)/:id([0-9]+)"];
        NSURL *url = URLWithPath(@"/table/randomTableName/109");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).notTo.beNil();
        expect(deepLink.routeParameters).to.equal(@{@"table": @"randomTableName",
                                                    @"id": @"109" });
    });

    it(@"does NOT return a deep link when the URL path does not match regex table parameter", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/table/:table([a-zA-Z]+)/:id([0-9])"];
        NSURL *url = URLWithPath(@"/table/table_name/109");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"does NOT return a deep link when the URL path does not match regex id parameter", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/table/:table([a-zA-Z]+)/:id([0-9])"];
        NSURL *url = URLWithPath(@"/table/tableName/1a9");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"matches a wildcard deeplink to route parameters", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/table/:path(.*)"];
        NSURL *url = URLWithPath(@"/table/some/path/which/should/be/in/route/parameters");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).notTo.beNil();
        expect(deepLink.routeParameters).to.equal(@{@"path": @"some/path/which/should/be/in/route/parameters"});
    });
    
});

SpecEnd
