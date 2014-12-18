#import "Specta.h"
#import "BTNDeepLinkRouter.h"
#import "BTNDeepLinkRouter_Private.h"
#import "BTNBookingRouteHandler.h"

SpecBegin(BTNDeepLinkRouter)

describe(@"Initialization", ^{
    
    it(@"returns an instance", ^{
        
    });
});


describe(@"Registering Routes", ^{
    
    __block BTNDeepLinkRouter *router;
    beforeEach(^{
        router = [[BTNDeepLinkRouter alloc] init];
    });
    
    
    context(@"Registering Class Handlers", ^{
        
        it(@"registers a class for a route", ^{
            router[@"table/book/:id"] = [BTNBookingRouteHandler class];
            expect(router.routes).to.contain(@"table/book/:id");
        });
        
        it(@"does not register a class not conforming to BTNDeepLinkRouteHandler protocol", ^{
            router[@"table/book/:id"] = [NSObject class];
            expect(router.routes).to.beEmpty();
        });
        
        it(@"does not register routes that are not strings", ^{
            router[@(0)] = [BTNBookingRouteHandler class];
            expect(router.routes).to.beEmpty();
        });
        
        it(@"registers a block for a route when the block type is correct", ^{
            router[@"table/book/:id"] = ^(BTNDeepLink *deepLink){};
            expect(router.routes).to.contain(@"table/book/:id");
        });
        
        xit(@"does NOT register a block for a route when the block type is incorrect", ^{
            router[@"table/book/:id"] = ^{};
            expect(router.routes).to.beEmpty();
        });
        
        it(@"does NOT register an empty route", ^{
            router[@""] = [BTNBookingRouteHandler class];
            expect(router.routes).to.beEmpty();
        });
        
        it(@"removes a route when passing a nil handler", ^{
            router[@"table/book/:id"] = [BTNBookingRouteHandler class];
            expect(router.routes).to.contain(@"table/book/:id");
            router[@"table/book/:id"] = nil;
            expect(router.routes).to.beEmpty();
        });
        
        it(@"replaces a block route handler for an existing class route handler", ^{
            NSString *route = @"table/book/:id";
            
            router[route] = [BTNBookingRouteHandler class];
            expect(router.classesByRoute[route]).to.equal([BTNBookingRouteHandler class]);
            expect(router.blocksByRoute).to.beEmpty();
            
            router[route] = ^(BTNDeepLink *deepLink){};
            expect(router.blocksByRoute[route]).to.beKindOf(NSClassFromString(@"NSBlock"));
            expect(router.classesByRoute).to.beEmpty();
        });
        
        xit(@"replaces a class route handler for an existing block route handler", ^{
            
        });
        
        fit(@"trims routes before registering", ^{
            router[@"/table/book/:id "]  = [BTNBookingRouteHandler class];
            router[@"/ride/book/:id \n"] = ^(BTNDeepLink *deepLink){};
            expect(router.routes).to.contain(@"table/book/:id");
            expect(router.routes).to.contain(@"ride/book/:id");
        });
    });
    
    
    context(@"Registering Block Handlers", ^{

        it(@"registers a block for a route", ^{
            
        });
    });
});

SpecEnd
