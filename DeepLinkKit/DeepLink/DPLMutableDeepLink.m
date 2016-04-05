#import "DPLMutableDeepLink.h"
#import "DPLDeepLink_Private.h"
#import "DPLDeepLink+AppLinks.h"
#import "NSString+DPLJSON.h"
#import "NSObject+DPLJSONObject.h"
#import "NSString+DPLQuery.h"

@interface DPLMutableDeepLink ()

@property (nonatomic, strong) NSURLComponents *URLComponents;

@end


@implementation DPLMutableDeepLink

@dynamic scheme, host, path;
@synthesize queryParameters=_queryParameters;

- (instancetype)initWithString:(NSString *)URLString {
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:URLString];
    if (!components) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _URLComponents       = components;
        _queryParameters     = [[self.URLComponents.query DPL_parametersFromQueryString] mutableCopy];
        _URLComponents.query = nil;
    }
    return self;
}


- (NSMutableDictionary *)queryParameters {
    if (!_queryParameters) {
        _queryParameters = [NSMutableDictionary dictionary];
    }
    return _queryParameters;
}


- (NSURL *)URL {

    NSDictionary *cleanParameters          = [self.queryParameters DPL_JSONObject];
    NSMutableDictionary *mutableParameters = [cleanParameters mutableCopy];
    NSMutableArray *JSONEncodedFieldNames  = [NSMutableArray array];
    
    [cleanParameters enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            mutableParameters[key] = [NSString DPL_stringWithJSONObject:value];
            [JSONEncodedFieldNames addObject:key];
        }
    }];
    
    if (JSONEncodedFieldNames.count) {
        NSString *encodedNames = [NSString DPL_stringWithJSONObject:JSONEncodedFieldNames];
        mutableParameters[DPLJSONEncodedFieldNamesKey] = encodedNames ?: @"";
    }
    
    cleanParameters = [NSDictionary dictionaryWithDictionary:mutableParameters];
    
    NSString *queryString = [NSString DPL_queryStringWithParameters:cleanParameters];
    self.URLComponents.percentEncodedQuery = queryString;
    
    return self.URLComponents.URL;
}


#pragma mark - Set Query Parameters via Object Subscripting

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key {
    if ([key isKindOfClass:[NSString class]] && key.length) {
        self.queryParameters[key] = obj;
    }
}


#pragma mark - NSObject

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.URLComponents;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    DPLDeepLink *copiedLink = [[DPLDeepLink alloc] initWithURL:self.URL];
    copiedLink.routeParameters = self.routeParameters;
    return copiedLink;
}


#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
    DPLMutableDeepLink *copiedLink = [[[self class] alloc] initWithString:self.URL.absoluteString];
    copiedLink.routeParameters = self.routeParameters;
    return copiedLink;
}

@end
