#import <Foundation/Foundation.h>

@interface BTNDeepLinkRouteMatcher : NSObject

/// Path component values keyed by params as defined in the route.
@property (nonatomic, strong) NSDictionary *params;

/**
 */
+ (instancetype)matcherWithRoute:(NSString *)route;


/**
 */
- (BOOL)matchesPath:(NSString *)path;

@end
