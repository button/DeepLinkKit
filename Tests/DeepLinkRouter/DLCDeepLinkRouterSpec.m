#import "Specta.h"
#import "DLCDeepLinkRouter.h"
#import "DLCDeepLinkRouter_Private.h"
#import "DLCBookingRouteHandler.h"

SpecBegin(DLCDeepLinkRouter)

describe(@"Initialization", ^{
    
    it(@"returns an instance", ^{
        expect([[DLCDeepLinkRouter alloc] init]).toNot.beNil();
    });
});


describe(@"Registering Routes", ^{
    
    NSString *route = @"table/book/:id";
    
    __block DLCDeepLinkRouter *router;
    beforeEach(^{
        router = [[DLCDeepLinkRouter alloc] init];
    });
    
    
    it(@"registers a class for a route", ^{
        router[route] = [DLCBookingRouteHandler class];
        expect(router[route]).to.equal([DLCBookingRouteHandler class]);
    });
    
    it(@"does NOT register a class not conforming to DLCDeepLinkRouteHandler protocol", ^{
        router[route] = [NSObject class];
        expect(router[route]).to.beNil();
    });
    
    it(@"does NOT register routes that are not strings", ^{
        router[@(0)] = [DLCBookingRouteHandler class];
        expect(router[route]).to.beNil();
    });
    
    it(@"registers a block for a route when the block takes a deep link", ^{
        router[route] = ^(DLCDeepLink *deepLink){};
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
        router[@""] = [DLCBookingRouteHandler class];
        expect(router[route]).to.beNil();
    });
    
    it(@"removes a route when passing a nil handler", ^{
        router[@"table/book/:id"] = [DLCBookingRouteHandler class];
        expect(router[route]).to.equal([DLCBookingRouteHandler class]);
        router[@"table/book/:id"] = nil;
        expect(router[route]).to.beNil();
    });
    
    it(@"replaces the registered handler for a route when one already exists", ^{
        router[route] = [DLCBookingRouteHandler class];
        expect(router[route]).to.equal([DLCBookingRouteHandler class]);

        router[route] = ^{};
        expect(router[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
    });
    
    it(@"replaces a registered class handler with a block handler", ^{
        router[route] = [DLCBookingRouteHandler class];
        expect(router.classesByRoute[route]).to.equal([DLCBookingRouteHandler class]);
        expect(router.blocksByRoute).to.beEmpty();
        
        router[route] = ^(DLCDeepLink *deepLink){};
        expect(router.blocksByRoute[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
        expect(router.classesByRoute).to.beEmpty();
    });
    
    it(@"replaces a registered block handler for a class handler", ^{
        router[route] = [DLCBookingRouteHandler class];
        expect(router.classesByRoute[route]).to.equal([DLCBookingRouteHandler class]);
        expect(router.blocksByRoute).to.beEmpty();
        
        router[route] = ^(DLCDeepLink *deepLink){};
        expect(router.blocksByRoute[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
        expect(router.classesByRoute).to.beEmpty();
    });
    
    it(@"trims routes before registering", ^{
        router[@"/table/book/:id \n"] = [DLCBookingRouteHandler class];
        expect(router[route]).to.equal([DLCBookingRouteHandler class]);
    });
    
    xit(@"matches routes in the order they were registered", ^{

    });
});

SpecEnd
