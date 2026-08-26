extern NSString * const DPLErrorDomain;

typedef NS_ENUM(NSInteger, DPLErrorCodes) {
    
    /** The passed URL does not match a registered route. */
    DPLRouteNotFoundError = 22023,
    
    /** The matched route handler does not specify a target view controller. */
    DPLRouteHandlerTargetNotSpecifiedError = 22024,
};
