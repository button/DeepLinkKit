#import "BTNDeepLink.h"

@interface BTNDeepLink ()

/**
 Initializes a deep link with a URL and route parameters.
 @warning Not intended for external consumption.
 @see BTNDeepLinkRouter
 */
- (instancetype)initWithURL:(NSURL *)url;

@end
