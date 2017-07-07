#import "DPLWontHandleRouteHandler.h"

@implementation DPLWontHandleRouteHandler

- (BOOL)shouldHandleDeepLink:(DPLDeepLink *)deepLink {
    return NO;
}

@end
