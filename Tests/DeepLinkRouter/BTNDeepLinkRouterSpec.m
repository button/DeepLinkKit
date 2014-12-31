#import "Specta.h"
#import "BTNDeepLinkRouter.h"
#import "BTNDeepLinkRouter_Private.h"
#import "BTNBookingRouteHandler.h"

SpecBegin(BTNDeepLinkRouter)

describe(@"Initialization", ^{
    
    it(@"returns an instance", ^{
        expect([[BTNDeepLinkRouter alloc] init]).toNot.beNil();
    });
});


describe(@"Registering Routes", ^{
    
    NSString *route = @"table/book/:id";
    
    __block BTNDeepLinkRouter *router;
    beforeEach(^{
        router = [[BTNDeepLinkRouter alloc] init];
    });
    
    
    it(@"registers a class for a route", ^{
        router[route] = [BTNBookingRouteHandler class];
        expect(router[route]).to.equal([BTNBookingRouteHandler class]);
    });
    
    it(@"does NOT register a class not conforming to BTNDeepLinkRouteHandler protocol", ^{
        router[route] = [NSObject class];
        expect(router[route]).to.beNil();
    });
    
    it(@"does NOT register routes that are not strings", ^{
        router[@(0)] = [BTNBookingRouteHandler class];
        expect(router[route]).to.beNil();
    });
    
    it(@"registers a block for a route when the block takes a deep link", ^{
        router[route] = ^(BTNDeepLink *deepLink){};
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
        router[@""] = [BTNBookingRouteHandler class];
        expect(router[route]).to.beNil();
    });
    
    it(@"removes a route when passing a nil handler", ^{
        router[@"table/book/:id"] = [BTNBookingRouteHandler class];
        expect(router[route]).to.equal([BTNBookingRouteHandler class]);
        router[@"table/book/:id"] = nil;
        expect(router[route]).to.beNil();
    });
    
    it(@"replaces the registered handler for a route when one already exists", ^{
        router[route] = [BTNBookingRouteHandler class];
        expect(router[route]).to.equal([BTNBookingRouteHandler class]);

        router[route] = ^{};
        expect(router[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
    });
    
    it(@"replaces a registered class handler with a block handler", ^{
        router[route] = [BTNBookingRouteHandler class];
        expect(router.classesByRoute[route]).to.equal([BTNBookingRouteHandler class]);
        expect(router.blocksByRoute).to.beEmpty();
        
        router[route] = ^(BTNDeepLink *deepLink){};
        expect(router.blocksByRoute[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
        expect(router.classesByRoute).to.beEmpty();
    });
    
    it(@"replaces a registered block handler for a class handler", ^{
        router[route] = [BTNBookingRouteHandler class];
        expect(router.classesByRoute[route]).to.equal([BTNBookingRouteHandler class]);
        expect(router.blocksByRoute).to.beEmpty();
        
        router[route] = ^(BTNDeepLink *deepLink){};
        expect(router.blocksByRoute[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
        expect(router.classesByRoute).to.beEmpty();
    });
    
    it(@"trims routes before registering", ^{
        router[@"/table/book/:id \n"] = [BTNBookingRouteHandler class];
        expect(router[route]).to.equal([BTNBookingRouteHandler class]);
    });
    
    xit(@"matches routes in the order they were registered", ^{

    });
});

SpecEnd
