#import "DPLMutableDeepLink.h"
#import "DPLDeepLink+AppLinks.h"

@interface DPLMutableDeepLink (AppLinks)

///--------------------------
/// @name App Link Properties
///--------------------------


/// The `target_url' as specified in the `al_applink_data' payload.
@property (nonatomic, copy, readwrite) NSURL *targetURL;


/// The `extras' payload as specified in the `al_applink_data' payload. Default is empty.
@property (nonatomic, copy, readwrite) NSMutableDictionary *extras;


/// The `user_agent' as specified in the `al_applink_data' payload.
@property (nonatomic, copy, readwrite) NSString *userAgent;


///-----------------------------------
/// @name Referrer App Link Properties
///-----------------------------------


/// The `target_url' as specified in the `referer_app_link' payload.
@property (nonatomic, copy, readwrite) NSURL *referrerTargetURL;


/// The `url' as specified in the `referer_app_link' payload.
@property (nonatomic, copy, readwrite) NSURL *referrerURL;


/// The `app_name' as specified in the `referer_app_link' payload.
@property (nonatomic, copy, readwrite) NSString *referrerAppName;

@end
