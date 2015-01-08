#import "DPLDeepLink+AppLinks.h"

NSString * const DPLAppLinksDataKey              = @"al_applink_data";
NSString * const DPLAppLinksTargetURLKey         = @"target_url";
NSString * const DPLAppLinksExtrasKey            = @"extras";
NSString * const DPLAppLinksVersionKey           = @"version";
NSString * const DPLAppLinksUserAgentKey         = @"user_agent";
NSString * const DPLAppLinksReferrerAppLinkKey   = @"referer_app_link";
NSString * const DPLAppLinksReferrerTargetURLKey = @"target_url";
NSString * const DPLAppLinksReferrerURLKey       = @"url";
NSString * const DPLAppLinksReferrerAppNameKey   = @"app_name";

@implementation DPLDeepLink (AppLinks)

@dynamic incomingURL, appLinkData;


#pragma mark - App Link Properties

- (NSURL *)targetURL {
    return self.appLinkData[DPLAppLinksTargetURLKey];
}


- (NSDictionary *)extras {
    return self.appLinkData[DPLAppLinksExtrasKey];
}


- (NSString *)version {
    return self.appLinkData[DPLAppLinksVersionKey];
}


- (NSString *)userAgent {
    return self.appLinkData[DPLAppLinksUserAgentKey];
}


#pragma mark - Referrer App Link Properties

- (NSURL *)referrerTargetURL {
    return self.appLinkData[DPLAppLinksReferrerAppLinkKey][DPLAppLinksReferrerTargetURLKey];
}


- (NSURL *)referrerURL {
    return self.appLinkData[DPLAppLinksReferrerAppLinkKey][DPLAppLinksReferrerURLKey];
}


- (NSString *)referrerAppName {
    return self.appLinkData[DPLAppLinksReferrerAppLinkKey][DPLAppLinksReferrerAppNameKey];
}

@end
