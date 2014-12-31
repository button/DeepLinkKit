#import "Specta.h"
#import "DLCDeepLinkRouteMatcher.h"
#import "DLCDeepLink.h"

NSURL *URLWithPath(NSString *path) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"dlc://dlc.com%@", path]];
}

SpecBegin(DLCDeepLinkRouteMatcher)

describe(@"Matching Routes", ^{
    
    it(@"returns a deep link when a URL matches a route", ^{
        DLCDeepLinkRouteMatcher *matcher = [DLCDeepLinkRouteMatcher matcherWithRoute:@"table/book"];
        NSURL *url = URLWithPath(@"/table/book");
        DLCDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"returns a deep link when a URL matches a parameterized route", ^{
        DLCDeepLinkRouteMatcher *matcher = [DLCDeepLinkRouteMatcher matcherWithRoute:@"table/book/:id"];
        NSURL *url = URLWithPath(@"/table/book/abc123");
        DLCDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"does NOT return a deep link when the URL and route dont match", ^{
        DLCDeepLinkRouteMatcher *matcher = [DLCDeepLinkRouteMatcher matcherWithRoute:@"table/book"];
        NSURL *url = URLWithPath(@"/table/book/abc123");
        DLCDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });

    it(@"does NOT return a deep link when the URL and parameterized route dont match", ^{
        DLCDeepLinkRouteMatcher *matcher = [DLCDeepLinkRouteMatcher matcherWithRoute:@"table/book/:id"];
        NSURL *url = URLWithPath(@"/table/book");
        DLCDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"does NOT return a deep link when the URL path does not match the route path", ^{
        DLCDeepLinkRouteMatcher *matcher = [DLCDeepLinkRouteMatcher matcherWithRoute:@"table/book/:id"];
        NSURL *url = URLWithPath(@"/ride/book");
        DLCDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"returns a deep link with route parameters when a URL matches a parameterized route", ^{
        DLCDeepLinkRouteMatcher *matcher = [DLCDeepLinkRouteMatcher matcherWithRoute:@"table/book/:id/:time"];
        NSURL *url = URLWithPath(@"/table/book/abc123/1418931000");
        DLCDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink.routeParameters).to.equal(@{ @"id": @"abc123", @"time": @"1418931000" });
    });
});

SpecEnd
