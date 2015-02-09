#import "DPLDeepLink.h"
#import "DPLDeepLink+AppLinks.h"
#import "DPLMutableDeepLink.h"
#import "NSString+DPLQuery.h"
#import "NSString+DPLJSON.h"
#import "NSObject+DPLJSONObject.h"

NSString * const DPLErrorDomain = @"com.usebutton.deeplink.error";

static NSString * const DPLCallbackURLKey = @"dpl_callback_url";

@implementation DPLDeepLink

- (instancetype)initWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        _URL = url;
        
        NSDictionary *queryParameters = [[url query] DPL_parametersFromQueryString];
        NSDictionary *appLinkData = [queryParameters[DPLAppLinksDataKey] DPL_decodedJSONObject];
        if (appLinkData) {
            _queryParameters = [[_URL query] DPL_parametersFromQueryString];
            NSMutableDictionary *mutableQueryParams = [_queryParameters mutableCopy];
            mutableQueryParams[DPLAppLinksDataKey]  = appLinkData;
            
            _queryParameters = [NSDictionary dictionaryWithDictionary:mutableQueryParams];
        }
        else {
            _queryParameters = queryParameters;
        }
    }
    return self;
}


- (NSURL *)callbackURL {
    NSString *URLString = self.queryParameters[DPLCallbackURLKey] ?: self.appLinkData[DPLAppLinksReferrerURLKey];
    return [NSURL URLWithString:URLString];
}


- (void)setRouteParameters:(NSDictionary *)routeParameters {
    _routeParameters = routeParameters;
}


- (NSString *)description {
    return [NSString stringWithFormat:
            @"\n<%@ %p\n"
            @"\t URL: \"%@\"\n"
            @"\t queryParameters: \"%@\"\n"
            @"\t routeParameters: \"%@\"\n"
            @"\t callbackURL: \"%@\"\n"
            @">",
            NSStringFromClass([self class]),
            self,
            [self.URL description],
            self.queryParameters,
            self.routeParameters,
            [self.callbackURL description]];
}


#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    else if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToDeepLink:object];
}


- (BOOL)isEqualToDeepLink:(DPLDeepLink *)deepLink {
    if (!deepLink) {
        return NO;
    }
    
    return (((!self.URL && !deepLink.URL) ||
             [self.URL isEqual:deepLink.URL]) &&
            
            ((!self.queryParameters && !deepLink.queryParameters) ||
             [self.queryParameters isEqualToDictionary:deepLink.queryParameters]) &&
            
            ((!self.routeParameters && !deepLink.routeParameters) ||
             [self.routeParameters isEqualToDictionary:deepLink.routeParameters]) &&
            
            ((!self.callbackURL && !deepLink.callbackURL) ||
             [self.callbackURL isEqual:deepLink.callbackURL]));
}


- (NSUInteger)hash {
    return [self.URL hash]
    ^ [self.queryParameters hash]
    ^ [self.routeParameters hash]
    ^ [self.callbackURL hash];
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithURL:self.URL];
}


#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[DPLMutableDeepLink alloc] initWithString:self.URL.absoluteString];
}


@end
