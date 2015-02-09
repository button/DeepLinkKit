#import "DPLDeepLink.h"
#import "DPLDeepLink+AppLinks.h"
#import "DPLMutableDeepLink.h"
#import "NSString+DPLQuery.h"
#import "NSString+DPLJSON.h"

NSString * const DPLErrorDomain = @"com.usebutton.deeplink.error";

static NSString * const DPLCallbackURLKey = @"dpl_callback_url";


@interface DPLDeepLink ()

@property (nonatomic, copy)   NSURL *incomingURL;
@property (nonatomic, strong) NSDictionary *appLinkData;

@end

@implementation DPLDeepLink

- (instancetype)initWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        NSDictionary *queryParameters = [[url query] DPL_parametersFromQueryString];
        _appLinkData = [queryParameters[DPLAppLinksDataKey] DPL_decodedJSONObject];
        if (_appLinkData) {
            _URL             = [NSURL URLWithString:_appLinkData[DPLAppLinksTargetURLKey]];
            _queryParameters = [[_URL query] DPL_parametersFromQueryString];
            _callbackURL     = [NSURL URLWithString:_appLinkData[DPLAppLinksReferrerAppLinkKey][DPLAppLinksReferrerURLKey]];
        }
        else {
            _URL             = url;
            _queryParameters = queryParameters;
            _callbackURL     = [NSURL URLWithString:_queryParameters[DPLCallbackURLKey]];
        }
    }
    return self;
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


#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[DPLDeepLink alloc] initWithURL:self.URL];
}


#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[DPLMutableDeepLink alloc] initWithString:self.URL.absoluteString];
}


@end
