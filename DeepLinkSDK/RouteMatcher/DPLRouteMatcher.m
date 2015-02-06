#import "DPLRouteMatcher.h"
#import "DPLDeepLink_Private.h"
#import "NSString+DPLTrim.h"

@interface DPLRouteMatcher ()

@property (nonatomic, copy) NSString  *host;
@property (nonatomic, strong) NSArray *routeParts;

@end

@implementation DPLRouteMatcher

+ (instancetype)matcherWithRoute:(NSString *)route {
    return [[self alloc] initWithRoute:route];
}


- (instancetype)initWithRoute:(NSString *)route {
    if (![route length]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        NSMutableArray *parts = [[route componentsSeparatedByString:@"/"] mutableCopy];
        
        if ([route rangeOfString:@"/"].location != 0) {
            _host = [parts firstObject];
        }
        
        // Remove the host/empty string.
        [parts removeObjectAtIndex:0];
        
        _routeParts = parts;
    }
    
    return self;
}


- (DPLDeepLink *)deepLinkWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    DPLDeepLink *deepLink     = [[DPLDeepLink alloc] initWithURL:url];
    NSMutableArray *pathParts = [[deepLink.URL pathComponents] mutableCopy];
    [pathParts removeObject:@"/"];
    
    BOOL isPathCountMatch = (pathParts.count == self.routeParts.count);
    BOOL isHostMatch      = !(self.host && ![self.host isEqualToString:deepLink.URL.host]);
    
    if (!isPathCountMatch || !isHostMatch) {
        return nil;
    }
    else if (isHostMatch && self.routeParts.count == 0) {
        return deepLink;
    }
    
    __block BOOL isMatch = NO;
    NSMutableDictionary *routeParameters = [NSMutableDictionary dictionary];
    
    [self.routeParts enumerateObjectsUsingBlock:^(NSString *routeComponent, NSUInteger idx, BOOL *stop) {
        NSString *pathComponent = pathParts[idx];
        
        if ([routeComponent rangeOfString:@":"].location == 0) {
            isMatch = YES;
            
            NSString *key = [routeComponent stringByReplacingOccurrencesOfString:@":" withString:@""];
            routeParameters[key] = pathComponent;
        }
        else if ([pathComponent isEqualToString:routeComponent]) {
            isMatch = YES;
        }
        else {
            isMatch = NO;
            *stop   = YES;
        }
    }];
    
    deepLink.routeParameters = routeParameters;
    
    return isMatch ? deepLink : nil;
}

@end
