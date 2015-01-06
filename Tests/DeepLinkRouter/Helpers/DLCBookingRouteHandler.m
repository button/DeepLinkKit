#import "DLCBookingRouteHandler.h"

@implementation DLCBookingRouteHandler

+ (BOOL)canHandleDeepLink:(DLCDeepLink *)deepLink {
    return YES;
}


- (BOOL)shouldDisplayDeepLink:(DLCDeepLink *)deepLink {
    return YES;
}


- (id <DLCTargetViewController>)targetViewController {
    return nil;
}

@end
