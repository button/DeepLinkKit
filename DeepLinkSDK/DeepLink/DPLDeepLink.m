#import "DPLDeepLink.h"
#import "DPLDeepLink+AppLinks.h"
#import "NSString+DPLQuery.h"
#import "NSString+DPLJSON.h"

NSString * const DPLErrorDomain = @"com.usebutton.deeplink.error";

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
        _appLinkData = [queryParameters[DPLAppLinksDataKey] DPL_JSONObject];
        if (_appLinkData) {
            _URL = [NSURL URLWithString:_appLinkData[DPLAppLinksTargetURLKey]];
            _queryParameters = [[_URL query] DPL_parametersFromQueryString];
        }
        else {
            _URL = url;
            _queryParameters = queryParameters;
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

@end
