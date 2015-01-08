#import "DPLDeepLink.h"

@interface DPLDeepLink ()

/**
 @warning Not intended for external consumption.
 @see DPLDeepLinkRouter
 */
- (instancetype)initWithURL:(NSURL *)url;

/**
 @warning Not intended for external consumption.
 @see DPLDeepLinkRouter
 */
- (void)setRouteParameters:(NSDictionary *)routeParameters;

@end
