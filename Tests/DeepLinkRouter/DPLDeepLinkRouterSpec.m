#import "Specta.h"
#import "DPLDeepLinkRouter.h"
#import "DPLDeepLinkRouter_Private.h"
#import "DPLRouteHandler.h"
#import "DPLErrors.h"

SpecBegin(DPLDeepLinkRouter)

describe(@"Initialization", ^{
    
    it(@"returns an instance", ^{
        expect([[DPLDeepLinkRouter alloc] init]).toNot.beNil();
    });
});


describe(@"Registering Routes", ^{
    
    NSString *route = @"table/book/:id";
    
    __block DPLDeepLinkRouter *router;
    beforeEach(^{
        router = [[DPLDeepLinkRouter alloc] init];
    });
    
    
    it(@"registers a class for a route", ^{
        router[route] = [DPLRouteHandler class];
        expect(router[route]).to.equal([DPLRouteHandler class]);
    });
    
    it(@"does NOT register a class not conforming to DPLRouteHandler protocol", ^{
        router[route] = [NSObject class];
        expect(router[route]).to.beNil();
    });
    
    it(@"does NOT register routes that are not strings", ^{
        router[@(0)] = [DPLRouteHandler class];
        expect(router[route]).to.beNil();
    });
    
    it(@"registers a block for a route when the block takes a deep link", ^{
        router[route] = ^(DPLDeepLink *deepLink){};
        expect(router[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
    });
    
    it(@"registers a block for a route when the block takes no params", ^{
        router[route] = ^{};
        expect(router[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
    });
    
    it(@"does NOT register an empty route", ^{
        router[@""] = [DPLRouteHandler class];
        expect(router[route]).to.beNil();
    });
    
    fit(@"does NOT register a NULL route handler", ^{
        router[route] = NULL;
        expect(router[route]).to.beNil();
    });
    
    it(@"removes a route when passing a nil handler", ^{
        router[@"table/book/:id"] = [DPLRouteHandler class];
        expect(router[route]).to.equal([DPLRouteHandler class]);
        router[@"table/book/:id"] = nil;
        expect(router[route]).to.beNil();
    });
    
    it(@"replaces the registered handler for a route when one already exists", ^{
        router[route] = [DPLRouteHandler class];
        expect(router[route]).to.equal([DPLRouteHandler class]);

        router[route] = ^{};
        expect(router[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
    });
    
    it(@"replaces a registered class handler with a block handler", ^{
        router[route] = [DPLRouteHandler class];
        expect(router.classesByRoute[route]).to.equal([DPLRouteHandler class]);
        expect(router.blocksByRoute).to.beEmpty();
        
        router[route] = ^(DPLDeepLink *deepLink){};
        expect(router.blocksByRoute[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
        expect(router.classesByRoute).to.beEmpty();
    });
    
    it(@"replaces a registered block handler for a class handler", ^{
        router[route] = [DPLRouteHandler class];
        expect(router.classesByRoute[route]).to.equal([DPLRouteHandler class]);
        expect(router.blocksByRoute).to.beEmpty();
        
        router[route] = ^(DPLDeepLink *deepLink){};
        expect(router.blocksByRoute[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
        expect(router.classesByRoute).to.beEmpty();
    });
    
    it(@"trims routes before registering", ^{
        router[@"/table/book/:id \n"] = [DPLRouteHandler class];
        expect(router[route]).to.equal([DPLRouteHandler class]);
    });
});


describe(@"Handling Routes", ^{

    NSURL *url = [NSURL URLWithString:@"dlc://dlc.com/say/hello/world"];
    
    __block DPLDeepLinkRouter *router;
    beforeEach(^{
        router = [[DPLDeepLinkRouter alloc] init];
    });
    
    xit(@"matches routes in the order they were registered", ^{
        
    });
    
    it(@"produces an error when a URL has no matching route", ^{
        waitUntil(^(DoneCallback done) {
            [router handleURL:url withCompletion:^(BOOL handled, NSError *error) {
                expect(handled).to.beFalsy();
                expect(error.code).to.equal(DPLRouteNotFoundError);
                done();
            }];
        });
    });
    
    it(@"produces an error when a route handler does not specify a target view controller", ^{
        waitUntil(^(DoneCallback done) {
            
            router[@"say/:title/:message"] = [DPLRouteHandler class];
            
            [router handleURL:url withCompletion:^(BOOL handled, NSError *error) {
                expect(handled).to.beFalsy();
                expect(error.code).to.equal(DPLRouteHandlerTargetNotSpecifiedError);
                done();
            }];
        });
    });
});

SpecEnd
