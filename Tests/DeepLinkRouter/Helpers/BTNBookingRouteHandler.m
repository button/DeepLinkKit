#import "BTNBookingRouteHandler.h"

@implementation BTNBookingRouteHandler

+ (BOOL)canHandleDeepLink:(BTNDeepLink *)deepLink {
    return YES;
}


- (BOOL)shouldDisplayDeepLink:(BTNDeepLink *)deepLink {
    return YES;
}


- (id <BTNDeepLinkTarget>)targetViewController {
    return nil;
}

@end
