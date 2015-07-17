@class DPLDeepLink;

/**
 Defines the block type to be used as the handler when registering a route.
 @param deepLink The deep link to be handled.
 @note It is not strictly necessary to register block-based route handlers.
 You can also register a class for a more structured approach.
 @see DPLRouteHandler
 */
typedef void(^DPLRouteHandlerBlock)(DPLDeepLink *deepLink);