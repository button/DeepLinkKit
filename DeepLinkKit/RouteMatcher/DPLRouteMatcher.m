#import "DPLRouteMatcher.h"
#import "DPLDeepLink_Private.h"
#import "NSString+DPLTrim.h"

static NSString * const DPLRouteParameterPattern = @":[a-zA-Z0-9-_]+";
static NSString * const DPLURLParameterPattern = @"([^/]+)";

@interface DPLRouteMatcher ()

@property (nonatomic, copy)   NSString  *route;
@property (nonatomic, strong) NSRegularExpression *regex;
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
    }
    
    return self;
}


- (NSRegularExpression *)regex {
    if (!_regex) {
        _routeParamaterNames = [NSMutableArray array];
        NSRegularExpression *parameterRegex = [NSRegularExpression regularExpressionWithPattern:DPLRouteParameterPattern
                                                                                        options:0
                                                                                          error:nil];
        
        __block NSString *modifiedRoute = [self.route copy];
        NSArray *matches = [parameterRegex matchesInString:self.route
                                                   options:0
                                                     range:NSMakeRange(0, self.route.length)];
        
        for (NSTextCheckingResult *result in matches) {
            
            NSString *stringToReplace   = [self.route substringWithRange:result.range];
            NSString *variableName      = [stringToReplace stringByReplacingOccurrencesOfString:@":"
                                                                                     withString:@""];
            [self.routeParamaterNames addObject:variableName];
            
            modifiedRoute = [modifiedRoute stringByReplacingOccurrencesOfString:stringToReplace
                                                                     withString:DPLURLParameterPattern];
        }
        
        modifiedRoute = [modifiedRoute stringByAppendingString:@"$"];
        _regex = [NSRegularExpression regularExpressionWithPattern:modifiedRoute
                                                           options:0
                                                             error:nil];
    }
    
    return _regex;
}


- (DPLDeepLink *)deepLinkWithURL:(NSURL *)url {
    
    DPLDeepLink *deepLink       = [[DPLDeepLink alloc] initWithURL:url];
    NSString *deepLinkString    = [NSString stringWithFormat:@"%@%@",
                                   deepLink.URL.host, deepLink.URL.path];
    NSArray *matches            = [self.regex matchesInString:deepLinkString
                                                      options:0
                                                        range:NSMakeRange(0, deepLinkString.length)];
    
    if (!matches.count) {
        return nil;
    }
    
    // Set route parameters in the routeParameters dictionary
    NSMutableDictionary *routeParameters = [NSMutableDictionary dictionary];
    for (NSTextCheckingResult *result in matches) {
        // Begin at 1 as first range is the whole match
        for (int i = 1; i < result.numberOfRanges && i <= self.routeParamaterNames.count; i++) {
            NSString *parameterName         = self.routeParamaterNames[i - 1];
            NSString *parameterValue        = [deepLinkString substringWithRange:[result rangeAtIndex:i]];
            routeParameters[parameterName]  = parameterValue;
        }
    }
    deepLink.routeParameters = routeParameters;
    
    return deepLink;
}

@end
