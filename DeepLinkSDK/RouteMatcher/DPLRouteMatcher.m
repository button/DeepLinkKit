#import "DPLRouteMatcher.h"
#import "DPLDeepLink_Private.h"
#import "NSString+DPLTrim.h"

@interface DPLRouteMatcher ()

@property (nonatomic, copy)   NSString *host;
@property (nonatomic, copy)   NSString *route;
@property (nonatomic, strong) NSArray  *routeParts;

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
        NSUInteger hostIdx = [route rangeOfString:@"]"].location;
        if ([route rangeOfString:@"["].location == 0 && hostIdx != NSNotFound) {
            _host = [route substringWithRange:NSMakeRange(1, hostIdx - 1)];
            _route = [route substringFromIndex:hostIdx + 1];
        } else {
            _route      = route;
        }
        _routeParts = [_route componentsSeparatedByString:@"/"];
    }
    
    return self;
}


- (DPLDeepLink *)deepLinkWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    DPLDeepLink *deepLink = [[DPLDeepLink alloc] initWithURL:url];
    if (_host != nil && ![[deepLink.URL host] isEqualToString:_host]) {
        return nil;
    }
    
    NSArray *pathParts = [[[deepLink.URL path] DPL_trimPath] componentsSeparatedByString:@"/"];
    if ([pathParts count] != [self.routeParts count]) {
        return nil;
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
