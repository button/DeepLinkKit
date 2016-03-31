@import Foundation;

@class DPLDeepLink;

@interface DPLDeepLink : NSObject <NSCopying, NSMutableCopying>



///-----------------
/// @name Properties
///-----------------


/**
 The serialized URL representation of the deep link.
 */
@property (nonatomic, copy, readonly) NSURL *URL;


/**
 The query parameters parsed from the incoming URL.
 @note If the URL conforms to the App Link standard, this will be the query parameters found on `target_url'.
 */
@property (nonatomic, copy, readonly) NSDictionary *queryParameters;


/**
 A dictionary of values keyed by their parameterized route component matched in the deep link URL path.
 @note Given a route `alert/:title/:message' and a path `button://alert/hello/world',
 the route parameters dictionary would be `@{ @"title": @"hello", @"message": @"world" }'.
 */
@property (nonatomic, copy, readonly) NSDictionary *routeParameters;


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



///--------------------------------------------------
/// @name Parameter Retrieval via Object Subscripting
///--------------------------------------------------

/**
 Both query and route parameters can be accessed concisely with object subscripting.
 @code
 id username = deepLink[@"username"];
 @endcode
 @note If the key is contained in both queryParameters and routeParameters, the value from routeParameters is returned.
 */
- (id)objectForKeyedSubscript:(NSString *)key;



///---------------
/// @name Equality
///---------------

/**
 Returns a Boolean value that indicates whether a given deep link is equal to the receiver.
 @param deepLink The App with which to compare to the receiver.
 @return YES if the deep link is equivalent to the receiver.
 */
- (BOOL)isEqualToDeepLink:(DPLDeepLink *)deepLink;

@end
