#import "DPLDeepLink.h"


/**
 If your deep link URLs follow the App Links standard, this category provides 
 easy access to the App Links defined properties. If not, these properties will be nil.
 */
@interface DPLDeepLink (AppLinks)


/// The `al_applink_data' payload found in the incoming URL.
@property (nonatomic, copy, readonly) NSDictionary *appLinkData;



///--------------------------
/// @name App Link Properties
///--------------------------


/// The `target_url' as specified in the `al_applink_data' payload.
@property (nonatomic, copy, readonly) NSURL *targetURL;


/// The `extras' payload as specified in the `al_applink_data' payload.
@property (nonatomic, copy, readonly) NSDictionary *extras;


/// The `version' as specified in the `al_applink_data' payload.
@property (nonatomic, copy, readonly) NSString *version;


/// The `user_agent' as specified in the `al_applink_data' payload.
@property (nonatomic, copy, readonly) NSString *userAgent;



///-----------------------------------
/// @name Referrer App Link Properties
///-----------------------------------


/// The `target_url' as specified in the `referer_app_link' payload.
@property (nonatomic, copy, readonly) NSURL *referrerTargetURL;


/// The `url' as specified in the `referer_app_link' payload.
@property (nonatomic, copy, readonly) NSURL *referrerURL;


/// The `app_name' as specified in the `referer_app_link' payload.
@property (nonatomic, copy, readonly) NSString *referrerAppName;


@end



///---------------------
/// @name App Links Keys
///---------------------


/// The key to retrieve `al_applink_data' from the incoming URL query parameters.
extern NSString * const DPLAppLinksDataKey;

/// The key to retrieve the `target_url' from the `al_applink_data' payload.
extern NSString * const DPLAppLinksTargetURLKey;

/// The key to retrieve the `extras' from the `al_applink_data' payload.
extern NSString * const DPLAppLinksExtrasKey;

/// The key to retrieve the `version' from the `al_applink_data' payload.
extern NSString * const DPLAppLinksVersionKey;

/// The key to retrieve the `user_agent' from the `al_applink_data' payload.
extern NSString * const DPLAppLinksUserAgentKey;

/// The key to retrieve the `referer_app_link' from the `al_applink_data' payload.
extern NSString * const DPLAppLinksReferrerAppLinkKey;

/// The key to retrieve the `target_url' from the `referer_app_link' payload.
extern NSString * const DPLAppLinksReferrerTargetURLKey;

/// The key to retrieve the `url' from the `referer_app_link' payload.
extern NSString * const DPLAppLinksReferrerURLKey;

/// The key to retrieve the `app_name' from the `referer_app_link' payload.
extern NSString * const DPLAppLinksReferrerAppNameKey;
