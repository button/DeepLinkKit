#import "DPLRouteHandlerBlockWrapper.h"

@implementation DPLRouteHandlerBlockWrapper

- (instancetype)initWithRouteHandlerBlock:(DPLRouteHandlerBlock)routeHandlerBlock
{
    self = [super init];
    if (self) {
        self.routeHandlerBlock = routeHandlerBlock;
    }
    return self;
}

@end