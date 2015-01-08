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
 @discussion Given a route `show/alert/:title/:message' and a path `button://show/alert/hello/world',
 the route parameters dictionary would be `@{ @"title": @"hello", @"message": @"world" }'.
 */
@property (nonatomic, strong, readonly) NSDictionary *routeParameters;


/** 
 */
@property (nonatomic, strong, readonly) NSURL *callbackURL;

@end
