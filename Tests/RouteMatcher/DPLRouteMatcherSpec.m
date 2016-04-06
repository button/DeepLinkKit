#import "DPLRouteMatcher.h"
#import "DPLDeepLink.h"

NSURL *URLWithPath(NSString *path) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"dpl://dpl.com%@", path]];
}

SpecBegin(DPLRouteMatcher)


describe(@"Initialization", ^{
    it(@"creates an instance with a route", ^{
        DPLRouteMatcher *routeMatcher = [DPLRouteMatcher matcherWithRoute:@"/thing/:another"];
        expect(routeMatcher).notTo.beNil();
    });
    
    it(@"does not create an instance with no route", ^{
        DPLRouteMatcher *routeMatcher = [DPLRouteMatcher matcherWithRoute:@""];
        expect(routeMatcher).to.beNil();
    });
});

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
    
    it(@"matches a wildcard deeplink to route parameters", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/table/:path(.*)"];
        NSURL *url = URLWithPath(@"/table/some/path/which/should/be/in/route/parameters");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).notTo.beNil();
        expect(deepLink.routeParameters).to.equal(@{@"path": @"some/path/which/should/be/in/route/parameters"});
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
    
    it(@"allows some named groups to be expressed with regex and not others", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/table/:table([a-zA-Z]+)/[a-z]+/:other([a-z]+)/:thing"];
        NSURL *url = URLWithPath(@"/table/anytable/anychair/another/anything");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).notTo.beNil();
        expect(deepLink.routeParameters).to.equal(@{@"table": @"anytable",
                                                    @"other": @"another",
                                                    @"thing": @"anything" });
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
    
    it(@"does NOT match partial strings", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"me"];
        NSURL *url = URLWithPath(@"home");
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"matches just a host as a named parameter", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@":host"];
        NSURL *url =  [NSURL URLWithString:@"scheme://myrandomhost?param1=value1&param2=value2"];
        DPLDeepLink *deepLink = [matcher deepLinkWithURL:url];
        
        expect(deepLink).notTo.beNil();
        expect([deepLink.queryParameters count]).to.equal(2);
        expect(deepLink.routeParameters[@"host"]).to.equal(@"myrandomhost");
    });
});


describe(@"Matching on Schemes", ^{
    
    __block NSURL *url1;
    __block NSURL *url2;
    beforeEach(^{
        url1 = [NSURL URLWithString:@"derp://dpl.io/say/hello"];
        url2 = [NSURL URLWithString:@"foo://dpl.io/say/hello"];
    });
    
    it(@"allows any scheme if not specified in the route", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"/say/hello"];
        DPLDeepLink *deepLink    = [matcher deepLinkWithURL:url1];
        expect(deepLink).toNot.beNil();

        deepLink = [matcher deepLinkWithURL:url2];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"matches a url with a scheme specific route", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"derp://(.*)/say/hello"];
        DPLDeepLink *deepLink    = [matcher deepLinkWithURL:url1];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"does NOT match a url with a different scheme than the route", ^{
        DPLRouteMatcher *matcher = [DPLRouteMatcher matcherWithRoute:@"derp://(.*)/say/hello"];
        DPLDeepLink *deepLink    = [matcher deepLinkWithURL:url2];
        expect(deepLink).to.beNil();
    });
});

SpecEnd
