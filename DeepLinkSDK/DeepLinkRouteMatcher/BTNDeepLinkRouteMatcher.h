#import <Foundation/Foundation.h>

@class BTNDeepLink;

@interface BTNDeepLinkRouteMatcher : NSObject

/**
 Initializes a route matcher.
 @param route The route to match.
 @return An route matcher instance.
 */
+ (instancetype)matcherWithRoute:(NSString *)route;


/**
 Matches a URL against the route and returns a deep link.
 @param url The url to be compared with the route.
 @return A BTNDeepLink instance if the URL matched the route, otherwise nil.
 */
- (BTNDeepLink *)deepLinkWithURL:(NSURL *)url;

@end
