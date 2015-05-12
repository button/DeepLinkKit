#import "DPLRouteMatcher.h"
#import "DPLDeepLink_Private.h"
#import "NSString+DPLTrim.h"
#import "DPLRegularExpression.h"

@interface DPLRouteMatcher ()

@property (nonatomic, copy)   NSString  *route;
@property (nonatomic, strong) DPLRegularExpression *regexMatcher;
@property (nonatomic, strong) NSMutableArray *routeParamaterNames;

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
        _route = route;
        _regexMatcher = [DPLRegularExpression regularExpressionWithPattern:route];
    }
    
    return self;
}


- (NSMutableArray *)routeParamaterNames {
    if (!_routeParamaterNames) {
        _routeParamaterNames = [NSMutableArray array];
    }
    return _routeParamaterNames;
}


- (DPLDeepLink *)deepLinkWithURL:(NSURL *)url {
    
    DPLDeepLink *deepLink       = [[DPLDeepLink alloc] initWithURL:url];
    NSString *deepLinkString    = [NSString stringWithFormat:@"%@%@",
                                   deepLink.URL.host, deepLink.URL.path];
    
    
    DPLMatchResult *matchResult = [self.regexMatcher matchResultForString:deepLinkString];
    if (!matchResult.isMatch) {
        return nil;
    }
    
    deepLink.routeParameters = matchResult.namedProperties;
    
    return deepLink;
}

@end
