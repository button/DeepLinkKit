#import "DPLBookingRouteHandler.h"

@implementation DPLBookingRouteHandler

+ (BOOL)canHandleDeepLinks {
    return YES;
}


- (BOOL)shouldHandleDeepLink:(DPLDeepLink *)deepLink {
    return YES;
}


- (id <DPLTargetViewController>)targetViewController {
    return nil;
}

@end
