#import "DPLRouteHandler.h"
#import "DPLTestRouteHandler.h"

@implementation DPLTestRouteHandler
- (UIViewController <DPLTargetViewController> *)targetViewController {
    return [[TestViewController alloc] init];
}
@end

@implementation TestViewController
- (void)configureWithDeepLink:(DPLDeepLink *)deepLink {}
@end

