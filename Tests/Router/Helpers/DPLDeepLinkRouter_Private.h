#import "DPLDeepLinkRouter.h"

@interface DPLDeepLinkRouter ()

@property (nonatomic, strong) NSMutableDictionary *classesByRoute;
@property (nonatomic, strong) NSMutableDictionary *blocksByRoute;
@property (nonatomic, strong) NSMutableDictionary *protocolsByRoute;

@end
