#import "DPLDeepLink.h"

/// A key into `queryParameters' that returns an array of keys where values have been JSON encoded.
extern NSString * const DPLJSONEncodedFieldNamesKey;


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
