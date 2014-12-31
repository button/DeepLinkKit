#import "DLCDeepLink.h"

@interface DLCDeepLink ()

/**
 Initializes a deep link with a URL and route parameters.
 @warning Not intended for external consumption.
 @see DLCDeepLinkRouter
 */
- (instancetype)initWithURL:(NSURL *)url;

@end
