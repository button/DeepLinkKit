#import "Specta.h"
#import "BTNDeepLinkRouteMatcher.h"
#import "BTNDeepLink.h"

NSURL *URLWithPath(NSString *path) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"dlc://dlc.com%@", path]];
}

SpecBegin(BTNDeepLinkRouteMatcher)

describe(@"Matching Routes", ^{
    
    it(@"returns a deep link when a URL matches a route", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book"];
        NSURL *url = URLWithPath(@"/table/book");
        BTNDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"returns a deep link when a URL matches a parameterized route", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book/:id"];
        NSURL *url = URLWithPath(@"/table/book/abc123");
        BTNDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).toNot.beNil();
    });
    
    it(@"does NOT return a deep link when the URL and route dont match", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book"];
        NSURL *url = URLWithPath(@"/table/book/abc123");
        BTNDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });

    it(@"does NOT return a deep link when the URL and parameterized route dont match", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book/:id"];
        NSURL *url = URLWithPath(@"/table/book");
        BTNDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"does NOT return a deep link when the URL path does not match the route path", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book/:id"];
        NSURL *url = URLWithPath(@"/ride/book");
        BTNDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink).to.beNil();
    });
    
    it(@"returns a deep link with route parameters when a URL matches a parameterized route", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book/:id/:time"];
        NSURL *url = URLWithPath(@"/table/book/abc123/1418931000");
        BTNDeepLink *deepLink = [matcher deepLinkWithURL:url];
        expect(deepLink.routeParameters).to.equal(@{ @"id": @"abc123", @"time": @"1418931000" });
    });
});

SpecEnd
