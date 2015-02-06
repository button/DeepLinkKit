#import "DPLRouteMatcher.h"
#import "DPLDeepLink_Private.h"
#import "NSString+DPLTrim.h"

static NSString * const DPLParameterRegexString = @":[a-zA-Z0-9-_]+";

@interface DPLRouteMatcher ()

@property (nonatomic, copy) NSString  *route;
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
        NSRegularExpression *parameterRegex = [NSRegularExpression regularExpressionWithPattern:DPLParameterRegexString options:0 error:nil];
        
        __block NSString *modifiedRoute = [self.route copy];
        [parameterRegex enumerateMatchesInString:self.route
                                         options:0
                                           range:NSMakeRange(0, self.route.length)
                                      usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                          NSString *stringToReplace = [self.route substringWithRange:result.range];
                                          NSString *variableName = [stringToReplace stringByReplacingOccurrencesOfString:@":" withString:@""];
                                          [self.routeParamaterNames addObject:variableName];
                                          
                                          NSString *replacementRegex = [NSString stringWithFormat:@"([a-zA-Z0-9-_]+)"];
                                          
                                          modifiedRoute = [modifiedRoute stringByReplacingOccurrencesOfString:stringToReplace withString:replacementRegex];
                                      }];
        
        modifiedRoute = [modifiedRoute stringByAppendingString:@"$"];
        
        _regex = [NSRegularExpression regularExpressionWithPattern:modifiedRoute options:0 error:nil];
    }
    return _regex;
}


- (DPLDeepLink *)deepLinkWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    DPLDeepLink *deepLink = [[DPLDeepLink alloc] initWithURL:url];
    
    NSArray *matches = [self.regex matchesInString:[deepLink.URL absoluteString]
                                           options:0
                                             range:NSMakeRange(0, [deepLink.URL absoluteString].length)];
    
    if (![matches count]) {
        return nil;
    }
    NSMutableDictionary *routeParameters = [NSMutableDictionary dictionary];
    for (NSTextCheckingResult *result in matches) {
        for (int i = 1; i < result.numberOfRanges && i <= self.routeParamaterNames.count; i++) {
            routeParameters[self.routeParamaterNames[i - 1]] = [[deepLink.URL absoluteString] substringWithRange:[result rangeAtIndex:i]];
        }
    }
    deepLink.routeParameters = routeParameters;
    
    return deepLink;
}

@end
