#import "UINavigationController+DPLRouting.h"

@interface VC1 : UIViewController @end
@implementation VC1 @end

@interface VC2 : UIViewController @end
@implementation VC2 @end

@interface VC3 : UIViewController @end
@implementation VC3 @end


SpecBegin(UINavigationController_DPLRouting)

describe(@"DPL_placeTargetViewController:", ^{
    
    VC1 *vc1 = [VC1 new];
    VC2 *vc2 = [VC2 new];
    VC3 *vc3 = [VC3 new];
    
    __block UINavigationController *nc;
    beforeEach(^{
        nc = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
    });
    
    it(@"pushes a view controller on the stack if not already present", ^{
        [nc DPL_placeTargetViewController:vc1];
        expect(nc.topViewController).to.equal(vc1);
    });
    
    it(@"pops to the view controller instance on the stack if already present", ^{
        [nc setViewControllers:@[vc1, vc2, vc3] animated:NO];
        [nc DPL_placeTargetViewController:vc2];
        expect(nc.topViewController).to.equal(vc2);
    });
    
    it(@"replaces existing instances of same view controller class already present on the stack", ^{
       [nc setViewControllers:@[vc1, vc2, vc3] animated:NO];
        VC2 *newvc2instance = [VC2 new];
        [nc DPL_placeTargetViewController:newvc2instance];
        expect(nc.topViewController).to.equal(newvc2instance);
        expect(nc.viewControllers).toNot.contain(vc2);
    });
});

SpecEnd
