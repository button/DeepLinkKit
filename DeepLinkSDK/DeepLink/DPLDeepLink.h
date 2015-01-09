#import <Foundation/Foundation.h>


@class DPLDeepLink, DPLAppAction;


@interface DPLDeepLink : NSObject

/**
 The incoming URL received by the application.
 @note If the URL conforms to the App Link standard, this will be `target_url' found in `al_applink_data'.
 */
@property (nonatomic, copy, readonly) NSURL *URL;


/**
 The query parameters parsed from the incoming URL.
 @note If the URL conforms to the App Link standard, this will be the query parameters found on `target_url'.
 */
@property (nonatomic, strong, readonly) NSDictionary *queryParameters;


/**
 A dictionary of values keyed by their parameterized route component matched in the deep link URL path.
 @note Given a route `alert/:title/:message' and a path `button://alert/hello/world',
 the route parameters dictionary would be `@{ @"title": @"hello", @"message": @"world" }'.
 */
@property (nonatomic, strong, readonly) NSDictionary *routeParameters;


/** 
 A deep link URL for linking back to the source application.
 @note A callback URL will be present if one is specified in the incoming deep link in the format oulined below
 or via the App Links standard.
 
 Callbacks can be specified in your deep link URLs with the `dpl_callback_url` parameter as follows:
 @code
 dpl://dpl.io/say/hello?dpl_callback_url=btn%3A%2F%2Fdpl.io%2Fsay%2Fhi
 @endcode
 */
@property (nonatomic, strong, readonly) NSURL *callbackURL;

@end
