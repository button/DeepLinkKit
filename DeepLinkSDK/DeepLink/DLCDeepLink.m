#import "DLCDeepLink.h"
#import "NSString+DLCQuery.h"
#import "NSString+DLCJSON.h"


NSString * const DLCAppLinkDataKey      = @"al_applink_data";
NSString * const DLCAppLinkTargetURLKey = @"target_url";
NSString * const DLCAppLinkExtrasKey    = @"extras";
NSString * const DLCAppLinkVersionKey   = @"version";
NSString * const DLCAppLinkUserAgentKey = @"user_agent";
NSString * const DLCReferrerAppLinkKey  = @"referer_app_link";


@implementation DLCDeepLink

- (instancetype)initWithURL:(NSURL *)url {
    if (!url) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        
        NSDictionary *queryParameters = [[url query] DLC_parametersFromQueryString];
        _appLinkData = [queryParameters[DLCAppLinkDataKey] DLC_JSONObject];
        if (_appLinkData) {
            _URL = [NSURL URLWithString:_appLinkData[DLCAppLinkTargetURLKey]];
            _queryParameters = [[_URL query] DLC_parametersFromQueryString];
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
