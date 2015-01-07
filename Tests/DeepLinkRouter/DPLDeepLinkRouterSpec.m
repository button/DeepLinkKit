#import "Specta.h"
#import "DPLDeepLinkRouter.h"
#import "DPLDeepLinkRouter_Private.h"
#import "DPLBookingRouteHandler.h"

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
        router[route] = [DPLBookingRouteHandler class];
        expect(router[route]).to.equal([DPLBookingRouteHandler class]);
    });
    
    it(@"does NOT register a class not conforming to DPLDeepLinkRouteHandler protocol", ^{
        router[route] = [NSObject class];
        expect(router[route]).to.beNil();
    });
    
    it(@"does NOT register routes that are not strings", ^{
        router[@(0)] = [DPLBookingRouteHandler class];
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
    
    xit(@"does NOT register a block for a route when the block type is incorrect", ^{
#pragma message "do we want to incpect the block type?"
    });
    
    it(@"does NOT register an empty route", ^{
        router[@""] = [DPLBookingRouteHandler class];
        expect(router[route]).to.beNil();
    });
    
    it(@"removes a route when passing a nil handler", ^{
        router[@"table/book/:id"] = [DPLBookingRouteHandler class];
        expect(router[route]).to.equal([DPLBookingRouteHandler class]);
        router[@"table/book/:id"] = nil;
        expect(router[route]).to.beNil();
    });
    
    it(@"replaces the registered handler for a route when one already exists", ^{
        router[route] = [DPLBookingRouteHandler class];
        expect(router[route]).to.equal([DPLBookingRouteHandler class]);

        router[route] = ^{};
        expect(router[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
    });
    
    it(@"replaces a registered class handler with a block handler", ^{
        router[route] = [DPLBookingRouteHandler class];
        expect(router.classesByRoute[route]).to.equal([DPLBookingRouteHandler class]);
        expect(router.blocksByRoute).to.beEmpty();
        
        router[route] = ^(DPLDeepLink *deepLink){};
        expect(router.blocksByRoute[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
        expect(router.classesByRoute).to.beEmpty();
    });
    
    it(@"replaces a registered block handler for a class handler", ^{
        router[route] = [DPLBookingRouteHandler class];
        expect(router.classesByRoute[route]).to.equal([DPLBookingRouteHandler class]);
        expect(router.blocksByRoute).to.beEmpty();
        
        router[route] = ^(DPLDeepLink *deepLink){};
        expect(router.blocksByRoute[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
        expect(router.classesByRoute).to.beEmpty();
    });
    
    it(@"trims routes before registering", ^{
        router[@"/table/book/:id \n"] = [DPLBookingRouteHandler class];
        expect(router[route]).to.equal([DPLBookingRouteHandler class]);
    });
    
    xit(@"matches routes in the order they were registered", ^{

    });
});

SpecEnd
