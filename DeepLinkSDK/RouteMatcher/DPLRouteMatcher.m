#import "DPLRouteMatcher.h"
#import "DPLDeepLink_Private.h"
#import "NSString+DPLTrim.h"
#import "DPLRegularExpression.h"

@interface DPLRouteMatcher ()

@property (nonatomic, strong) DPLRegularExpression *regexMatcher;

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
        _regexMatcher = [DPLRegularExpression regularExpressionWithPattern:route];
    }
    
    return self;
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
