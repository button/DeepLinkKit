#import "DPLRouteMatcher.h"
#import "DPLDeepLink_Private.h"
#import "NSString+DPLTrim.h"
#import "DPLRegularExpression.h"

@interface DPLRouteMatcher ()

@property (nonatomic, copy)   NSString *scheme;
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
        
        NSArray *parts = [route componentsSeparatedByString:@"://"];
        _scheme = parts.count > 1 ? [parts firstObject] : nil;
        _regexMatcher = [DPLRegularExpression regularExpressionWithPattern:[parts lastObject]];
    }
    
    return self;
}


- (DPLDeepLink *)deepLinkWithURL:(NSURL *)url {
    
    DPLDeepLink *deepLink       = [[DPLDeepLink alloc] initWithURL:url];
    NSString *deepLinkString    = [NSString stringWithFormat:@"%@%@", deepLink.URL.host, deepLink.URL.path];
    
    if (self.scheme.length && ![self.scheme isEqualToString:deepLink.URL.scheme]) {
        return nil;
    }
    
    DPLMatchResult *matchResult = [self.regexMatcher matchResultForString:deepLinkString];
    if (!matchResult.isMatch) {
        return nil;
    }
    
    deepLink.routeParameters = matchResult.namedProperties;
    
    return deepLink;
}

@end
