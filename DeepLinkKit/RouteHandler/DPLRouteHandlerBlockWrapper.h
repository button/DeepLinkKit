#import <Foundation/Foundation.h>
#import "DPLRouteHandlerBlock.h"

@class DPLDeepLink;

@interface DPLRouteHandlerBlockWrapper : NSObject

@property (nonatomic, copy) DPLRouteHandlerBlock routeHandlerBlock;

- (instancetype)initWithRouteHandlerBlock:(DPLRouteHandlerBlock)routeHandlerBlock;

@end