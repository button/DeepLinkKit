#import "DPLMutableDeepLink+AppLinks.h"

@implementation DPLMutableDeepLink (AppLinks)


#pragma mark - App Link Properties

- (void)setTargetURL:(NSURL *)targetURL {
    self.mutableAppLinkData[DPLAppLinksTargetURLKey] = targetURL.absoluteString ?: @"";
}


- (void)setUserAgent:(NSString *)userAgent {
    self.mutableAppLinkData[DPLAppLinksUserAgentKey] = userAgent ?: @"";
}


- (void)setExtras:(NSMutableDictionary *)extras {
    self.mutableAppLinkData[DPLAppLinksExtrasKey] = [extras copy] ?: @{};
}


- (NSMutableDictionary *)extras {
    NSMutableDictionary *extras = self.mutableAppLinkData[DPLAppLinksExtrasKey];
    if (!extras) {
        extras = [NSMutableDictionary dictionary];
        self.mutableAppLinkData[DPLAppLinksExtrasKey] = extras;
    }
    return extras;
}


#pragma mark - Referrer App Link Properties

- (void)setReferrerTargetURL:(NSURL *)referrerTargetURL {
    self.mutableReferrerData[DPLAppLinksReferrerTargetURLKey] = referrerTargetURL.absoluteString ?: @"";
}


- (void)setReferrerURL:(NSURL *)referrerURL {
    self.mutableReferrerData[DPLAppLinksReferrerURLKey] = referrerURL.absoluteString ?: @"";
}


- (void)setReferrerAppName:(NSString *)referrerAppName {
    self.mutableReferrerData[DPLAppLinksReferrerAppNameKey] = referrerAppName ?: @"";
}


#pragma mark - Private

- (NSMutableDictionary *)mutableAppLinkData {
    NSMutableDictionary *data = self.queryParameters[DPLAppLinksDataKey];
    if (!data) {
        data = [NSMutableDictionary dictionary];
        data[DPLAppLinksVersionKey] = @"1.0";
        self.queryParameters[DPLAppLinksDataKey] = data;
    }
    return data;
}


- (NSMutableDictionary *)mutableReferrerData {
    NSMutableDictionary *data = self.mutableAppLinkData[DPLAppLinksReferrerAppLinkKey];
    if (!data) {
        data = [NSMutableDictionary dictionary];
        self.mutableAppLinkData[DPLAppLinksReferrerAppLinkKey] = data;
    }
    return data;
}

@end
