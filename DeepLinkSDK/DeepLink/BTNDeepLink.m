#import "BTNDeepLink.h"
#import "NSString+BTNQuery.h"
#import "NSString+BTNJSON.h"

NSString * const BTNDeepLinkPayloadKey         = @"al_applink_data";
NSString * const BTNDeepLinkTargetURLKey       = @"target_url";
NSString * const BTNDeepLinkReferrerURLKey     = @"url";
NSString * const BTNDeepLinkReferrerAppNameKey = @"app_name";
NSString * const BTNDeepLinkExtrasKey          = @"extras";
NSString * const BTNDeepLinkAppLinksVersionKey = @"version";
NSString * const BTNDeepLinkDLCVersionKey      = @"btn_dlc_version";
NSString * const BTNDeepLinkUserAgentKey       = @"user_agent";
NSString * const BTNDeepLinkReferrerPayloadKey = @"referer_app_link";

@implementation BTNDeepLink

- (instancetype)initWithURL:(NSURL *)url {
    self = [super init];
    if (self) {
        _incomingURL             = url;
        _incomingQueryParameters = [[url query] BTN_parametersFromQueryString];
        _payload                 = [_incomingQueryParameters[BTNDeepLinkPayloadKey] BTN_JSONObject];
        _targetURL               = [NSURL URLWithString:_payload[BTNDeepLinkTargetURLKey]];
        _targetQueryParameters   = [[_targetURL query] BTN_parametersFromQueryString];

        NSArray *pathComponents = [_targetURL pathComponents];
        _useCase  = ([pathComponents count] > 1) ? pathComponents[1] : nil;
        _action   = ([pathComponents count] > 2) ? pathComponents[2] : nil;
        _objectId = ([pathComponents count] > 3) ? pathComponents[3] : nil;
    }
    return self;
}


+ (void)resolveURL:(NSURL *)url completionHandler:(BTNDeepLinkResolveCompletion)completionHandler {
    BTNDeepLink *deepLink = [[self alloc] initWithURL:url];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (completionHandler) {
            completionHandler(deepLink, nil);
        }
    });
}


- (NSString *)description {
    return [NSString stringWithFormat:
            @"\n<%@ %p\n"
            @"\t useCase: \"%@\"\n"
            @"\t action: \"%@\"\n"
            @"\t objectId: \"%@\"\n"
            @"\t targetURL: \"%@\"\n"
            @"\t targetQueryParameters: \"%@\"\n"
            @"\t incomingURL: \"%@\"\n"
            @"\t incomingQueryParameters: \"%@\"\n"
            @">",
            NSStringFromClass([self class]),
            self,
            self.useCase,
            self.action,
            self.objectId,
            [self.targetURL description],
            [self.targetQueryParameters description],
            [self.incomingURL description],
            [self.incomingQueryParameters description]];
}

@end
