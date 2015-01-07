#import "DPLDeepLink.h"
#import "NSString+DPLQuery.h"
#import "NSString+DPLJSON.h"


NSString * const DPLAppLinkDataKey      = @"al_applink_data";
NSString * const DPLAppLinkTargetURLKey = @"target_url";
NSString * const DPLAppLinkExtrasKey    = @"extras";
NSString * const DPLAppLinkVersionKey   = @"version";
NSString * const DPLAppLinkUserAgentKey = @"user_agent";
NSString * const DPLReferrerAppLinkKey  = @"referer_app_link";


@implementation DPLDeepLink

- (instancetype)initWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        NSDictionary *queryParameters = [[url query] DPL_parametersFromQueryString];
        _appLinkData = [queryParameters[DPLAppLinkDataKey] DPL_JSONObject];
        if (_appLinkData) {
            _URL = [NSURL URLWithString:_appLinkData[DPLAppLinkTargetURLKey]];
            _queryParameters = [[_URL query] DPL_parametersFromQueryString];
        }
        else {
            _URL = url;
            _queryParameters = queryParameters;
        }
    }
    return self;
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

@end
