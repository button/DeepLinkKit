#import <Foundation/Foundation.h>

@interface BTNDeepLinkRouteMatcher : NSObject

+ (instancetype)matcherWithRoute:(NSString *)route;

- (BOOL)matchesPath:(NSString *)path;

@end
