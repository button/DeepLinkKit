@import Foundation;

@class DPLDeepLink;

@interface DPLRouteMatcher : NSObject

/**
 Initializes a route matcher.
 @param route The route to match.
 @return An route matcher instance.
 */
+ (instancetype)matcherWithRoute:(NSString *)route;


/**
 Matches a URL against the route and returns a deep link.
 @param url The url to be compared with the route.
 @return A DPLDeepLink instance if the URL matched the route, otherwise nil.
 */
- (DPLDeepLink *)deepLinkWithURL:(NSURL *)url;

@end
