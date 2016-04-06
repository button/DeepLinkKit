#import "DPLDeepLink.h"
#import "DPLDeepLink_Private.h"
#import "DPLDeepLink+AppLinks.h"
#import "DPLMutableDeepLink.h"
#import "NSString+DPLQuery.h"
#import "NSString+DPLJSON.h"
#import "NSObject+DPLJSONObject.h"

NSString * const DPLErrorDomain              = @"com.usebutton.deeplink.error";
NSString * const DPLCallbackURLKey           = @"dpl_callback_url";
NSString * const DPLJSONEncodedFieldNamesKey = @"dpl:json-encoded-fields";


@implementation DPLDeepLink

- (instancetype)initWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        _URL             = url;
        _queryParameters = [[_URL query] DPL_parametersFromQueryString];
        
        NSMutableDictionary *mutableQueryParams = [_queryParameters mutableCopy];
        NSArray *JSONEncodedFields = [mutableQueryParams[DPLJSONEncodedFieldNamesKey] DPL_decodedJSONObject];
        
        [_queryParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            if ([JSONEncodedFields containsObject:key]
                || [key isEqualToString:DPLAppLinksDataKey]) {
                mutableQueryParams[key] = [value DPL_decodedJSONObject] ?: value;
            }
        }];
        
        _queryParameters = [NSDictionary dictionaryWithDictionary:mutableQueryParams];
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


#pragma mark - Parameter Retrieval via Object Subscripting

- (id)objectForKeyedSubscript:(NSString *)key {
    id value  = self.routeParameters[key];
    if (!value) {
        value = self.queryParameters[key];
    }
    return value;
}


#pragma mark - Equality

- (BOOL)isEqual:(id)object {
    return [self isEqualToDeepLink:object];
}


- (BOOL)isEqualToDeepLink:(DPLDeepLink *)deepLink {
    if (self == deepLink) {
        return YES;
    }
    else if (![deepLink isKindOfClass:[self class]]) {
        return NO;
    }
    
    return (!self.URL && !deepLink.URL) || [self.URL isEqual:deepLink.URL];
}


- (NSUInteger)hash {
    return [self.URL hash];
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    DPLDeepLink *copiedLink = [[[self class] alloc] initWithURL:self.URL];
    copiedLink.routeParameters = self.routeParameters;
    return copiedLink;
}


#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
    DPLMutableDeepLink *copiedLink = [[DPLMutableDeepLink alloc] initWithString:self.URL.absoluteString];
    copiedLink.routeParameters = self.routeParameters;
    return copiedLink;
}


@end
