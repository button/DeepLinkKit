#import <Foundation/Foundation.h>

@class    BTNDeepLink;
@protocol BTNDeepLinkRouteHandler;

typedef void(^BTNDeepLinkRouteHandlerBlock)(BTNDeepLink *deepLink);


@interface BTNDeepLinkRouter : NSObject

/// A set of registered deep link routes.
@property (nonatomic, copy, readonly) NSOrderedSet *routes;



///-------------------------
/// @name Route Registration
///-------------------------


/**
 Registers a class conforming to the `BTNDeepLinkRouteHandler' protocol for a given route.
 @param handlerClass A class for handling a specific route.
 @param route The route (e.g. @"table/book/:id", @"ride/book", etc) that when matched uses the registered class to handle the deep link.
 
 @discussion You can also use the object literal syntax to register routes.
 For example, you can register a class for a route as follows:
 @code deepLinkRouter[@"table/book/:id"] = [MyBookingRouteHandler class]; @endcode
 */
- (void)registerHandlerClass:(Class <BTNDeepLinkRouteHandler>)handlerClass forRoute:(NSString *)route;


/**
 Registers a block for a given route.
 @param routeHandlerBlock A block to be executed when the specified route is matched.
 @param route The route (e.g. @"table/book/:id", @"ride/book", etc) that when matched executes the registered block to handle the deep link.
 
 @discussion You can also use the object literal syntax to register routes.
 For example, you can register a route handler block as follows:
 @code 
 deepLinkRouter[@"table/book/:id"] = ^(BTNDeepLink *deepLink) {
    // Handle the link here.
 };
 @endcode
 @note Registering a class conforming to `BTNDeepLinkRouteHandler' is the preferred method of route registration. 
 Only register blocks for trivial cases or for actions that do not require UI presentation.
 */
- (void)registerBlock:(BTNDeepLinkRouteHandlerBlock)routeHandlerBlock forRoute:(NSString *)route;



///--------------------------
/// @name Object Subscripting
///--------------------------


/**
 Though not typically necessary, route handlers can be retrieved as follows:
 @code
 id handler = deepLinkRouter[@"table/book/:id"];
 @endcode
 */
- (id)objectForKeyedSubscript:(id <NSCopying>)key;


/**
 You can also register your routes in the following way:
 @code
 deepLinkRouter[@"table/book/:id"] = [MyBookingRouteHandler class];
 
 // or
 
 deepLinkRouter[@"table/book/:id"] = ^(BTNDeepLink *deepLink) {
 // Handle the link here.
 }
 @endcode
 */
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

@end
