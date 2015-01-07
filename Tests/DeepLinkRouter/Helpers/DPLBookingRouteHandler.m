#import "DPLBookingRouteHandler.h"

@implementation DPLBookingRouteHandler

+ (BOOL)canHandleDeepLink:(DPLDeepLink *)deepLink {
    return YES;
}


- (BOOL)shouldDisplayDeepLink:(DPLDeepLink *)deepLink {
    return YES;
}


- (id <DPLTargetViewController>)targetViewController {
    return nil;
}

@end
