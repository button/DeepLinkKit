#import "DPLDeepLink.h"

@interface DPLDeepLink ()

/**
 Initializes a deep link with a URL and route parameters.
 @warning Not intended for external consumption.
 @see DPLDeepLinkRouter
 */
- (instancetype)initWithURL:(NSURL *)url;

@end
