#import "DPLMutableDeepLink.h"
#import "DPLDeepLink_Private.h"
#import "NSString+DPLJSON.h"
#import "NSObject+DPLJSONObject.h"
#import "NSString+DPLQuery.h"


@interface DPLMutableDeepLink ()

@property (nonatomic, strong) NSURLComponents *URLComponents;

@end


@implementation DPLMutableDeepLink

@dynamic scheme, host, path;

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


- (NSURL *)URL {
    
    NSDictionary *safeParameters = [self.queryParameters DPL_JSONObject];
    NSString *queryString = [NSString DPL_queryStringWithParameters:safeParameters];
    self.URLComponents.percentEncodedQuery = queryString;
    
    return self.URLComponents.URL;
}


#pragma mark - NSObject

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.URLComponents;
}


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[DPLDeepLink alloc] initWithURL:self.URL];
}


#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[DPLMutableDeepLink alloc] initWithString:self.URL.absoluteString];
}

@end
