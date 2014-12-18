#import "Specta.h"
#import "BTNDeepLinkRouteMatcher.h"

SpecBegin(BTNDeepLinkRouteMatcher)

describe(@"Matching Routes", ^{
    
    it(@"matches a path to a route", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book"];
        expect([matcher matchesPath:@"table/book"]).to.beTruthy();
    });
    
    it(@"matches an untrimmed path to a route", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book"];
        expect([matcher matchesPath:@"/table/book/ "]).to.beTruthy();
    });
    
    it(@"matches a path to a parameterized route", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book/:id"];
        expect([matcher matchesPath:@"table/book/12345"]).to.beTruthy();
    });
    
    it(@"does not match an invalid path to a route", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book"];
        expect([matcher matchesPath:@"table/book/12345"]).to.beFalsy();
    });

    it(@"does not match an invalid path to a parameterized route", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book/:id"];
        expect([matcher matchesPath:@"table/book/12345/derp"]).to.beFalsy();
    });
    
    it(@"does not match an incorrect path to a route", ^{
        BTNDeepLinkRouteMatcher *matcher = [BTNDeepLinkRouteMatcher matcherWithRoute:@"table/book/:id"];
        expect([matcher matchesPath:@"ride/book/12345"]).to.beFalsy();
    });
});

SpecEnd
