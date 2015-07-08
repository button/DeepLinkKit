@class DPLDeepLink;

@interface DPLMatchedRoute : NSObject

@property (nonatomic, strong) DPLDeepLink *deepLink;
@property (nonatomic, strong) id handler;

- (instancetype)initWithDeepLink:(DPLDeepLink *)deepLink handler:(id)handler;

+ (instancetype)routeWithDeepLink:(DPLDeepLink *)deepLink handler:(id)handler;


@end
