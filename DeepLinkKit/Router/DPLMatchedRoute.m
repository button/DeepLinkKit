#import "DPLMatchedRoute.h"

@implementation DPLMatchedRoute

- (instancetype)initWithDeepLink:(DPLDeepLink *)deepLink handler:(id)handler {
    self = [super init];
    if (self) {
        self.deepLink = deepLink;
        self.handler = handler;
    }

    return self;
}

+ (instancetype)routeWithDeepLink:(DPLDeepLink *)deepLink handler:(id)handler {
    return [[self alloc] initWithDeepLink:deepLink handler:handler];
}

@end