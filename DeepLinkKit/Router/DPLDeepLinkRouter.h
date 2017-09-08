@import Foundation;

@class DPLDeepLink;


/**
 Defines the block type to be used as the handler when registering a route.
 @param deepLink The deep link to be handled.
 @note It is not strictly necessary to register block-based route handlers. 
 You can also register a class for a more structured approach.
 @see DPLRouteHandler
 */
typedef void(^DPLRouteHandlerBlock)(DPLDeepLink *deepLink);


/**
 Defines a block type used to determine whether your application can handle deep links.
 @return Whether or not your application can handle deep links at the time the block is executed.
 @discussion For example, you might return NO if no user is logged in.
 */
typedef BOOL(^DPLApplicationCanHandleDeepLinksBlock)(void);


/**
 The completion block definition for `routeURL:withCompletion:'
 @param handled Indicates whether or not the deep link was handled.
 @param error An error if one occurred while handling a deep link URL.
 */
typedef void(^DPLRouteCompletionBlock)(BOOL handled, NSError *error);



@interface DPLDeepLinkRouter : NSObject


///-------------------------
/// @name Route Registration
///-------------------------


/**
 Registers a subclass of `DPLRouteHandler' for a given route.
 @param handlerClass A class for handling a specific route.
 @param route The route (e.g. @"table/book/:id", @"ride/book", etc) that when matched uses the registered class to handle the deep link.
 
 @discussion You can also use the object literal syntax to register routes.
 For example, you can register a class for a route as follows:
 @code deepLinkRouter[@"table/book/:id"] = [MyBookingRouteHandler class]; @endcode
 */
- (void)registerHandlerClass:(Class)handlerClass forRoute:(NSString *)route;


/**
 Registers a block for a given route.
 @param routeHandlerBlock A block to be executed when the specified route is matched.
 @param route The route (e.g. @"table/book/:id", @"ride/book", etc) that when matched executes the registered block to handle the deep link.
 
 @discussion You can also use the object literal syntax to register routes.
 For example, you can register a route handler block as follows:
 @code 
 deepLinkRouter[@"table/book/:id"] = ^(DPLDeepLink *deepLink) {
    // Handle the link here.
 };
 @endcode
 @note Registering a subclass of `DPLRouteHandler' is the preferred method of route registration.
 Only register blocks for trivial cases or for actions that do not require UI presentation.
 */
- (void)registerBlock:(DPLRouteHandlerBlock)routeHandlerBlock forRoute:(NSString *)route;


/**
 A Swift friendly version of -registerBlock:forRoute:
 
 @see -registerBlock:forRoute:
 */
- (void)register:(NSString *)route routeHandlerBlock:(DPLRouteHandlerBlock)routeHandlerBlock;



///-------------------------
/// @name Routing Deep Links
///-------------------------


/**
 Attempts to handle an incoming URL.
 @param url The incoming URL from `application:openURL:sourceApplication:annotation:'
 @param completionHandler A block executed after the deep link has been handled.
 @return YES if the incoming URL is handled, otherwise NO.
 
 @see DPLRouteCompletionBlock
 */
- (BOOL)handleURL:(NSURL *)url withCompletion:(DPLRouteCompletionBlock)completionHandler;


/**
 Attempts to handle an incoming user activity.
 @param userActivity The incoming user activity from `application:continueUserActivity:restorationHandler:'
 @param completionHandler A block executed after the user activity has been handled.
 @return YES if the incoming user activity is handled, otherwise NO.
 
 @see DPLRouteCompletionBlock
 */
- (BOOL)handleUserActivity:(NSUserActivity *)userActivity withCompletion:(DPLRouteCompletionBlock)completionHandler;


///--------------------
/// @name Configuration
///--------------------


/**
 Sets a block which, when executed, returns whether your application is in a state where it can handle deep links.
 @param applicationCanHandleDeepLinksBlock A block to be executed for each URL received by the application.
 @discussion By default, all matched URLs will be handled. If you require disabling deep link support based
 on some application state (e.g. no user logged in) then you should provide a block to this method.
 */
- (void)setApplicationCanHandleDeepLinksBlock:(DPLApplicationCanHandleDeepLinksBlock)applicationCanHandleDeepLinksBlock;



///-------------------------------------------------
/// @name Route Registration via Object Subscripting
///-------------------------------------------------


/**
 You can also register your routes in the following way:
 @code
 deepLinkRouter[@"table/book/:id"] = [MyBookingRouteHandler class];
 
 // or
 
 deepLinkRouter[@"table/book/:id"] = ^(DPLDeepLink *deepLink) {
 // Handle the link here.
 }
 @endcode
 */
- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key
NS_SWIFT_UNAVAILABLE("Available in Swift as: register(route: String, routeHandlerBlock: (DPLDeepLink) -> ())");


/**
 Though not recommended, route handlers can be retrieved as follows:
 @code
 id handler = deepLinkRouter[@"table/book/:id"];
 @endcode
 @note The type of the returned handler is the type you registered for that route.
 */
- (id)objectForKeyedSubscript:(NSString *)key NS_SWIFT_UNAVAILABLE("Not Available");

@end
