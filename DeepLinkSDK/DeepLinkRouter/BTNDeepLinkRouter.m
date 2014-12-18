#import "BTNDeepLinkRouter.h"
#import "BTNDeepLinkRouteHandlerProtocol.h"
#import "NSString+BTNTrim.h"
#import <objc/runtime.h>

@interface BTNDeepLinkRouter ()

@property (nonatomic, strong) NSMutableOrderedSet *mutableRoutes;
@property (nonatomic, strong) NSMutableDictionary *classesByRoute;
@property (nonatomic, strong) NSMutableDictionary *blocksByRoute;

@end


@implementation BTNDeepLinkRouter

- (instancetype)init {
    self = [super init];
    if (self) {
        _mutableRoutes  = [NSMutableOrderedSet orderedSet];
        _classesByRoute = [NSMutableDictionary dictionary];
        _blocksByRoute  = [NSMutableDictionary dictionary];
    }
    return self;
}


- (NSOrderedSet *)routes {
    return [self.mutableRoutes copy];
}


- (void)registerHandlerClass:(Class <BTNDeepLinkRouteHandler>)handlerClass forRoute:(NSString *)route {

    route = [route BTN_trimPath];
    
    if (handlerClass && [route length]) {
        [self.mutableRoutes addObject:route];
        [self.blocksByRoute removeObjectForKey:route];
        self.classesByRoute[route] = handlerClass;
    }
}


- (void)registerBlock:(BTNDeepLinkRouteHandlerBlock)routeHandlerBlock forRoute:(NSString *)route {

    route = [route BTN_trimPath];
    
    if (routeHandlerBlock && [route length]) {
        [self.mutableRoutes addObject:route];
        [self.classesByRoute removeObjectForKey:route];
        self.blocksByRoute[route] = [routeHandlerBlock copy];
    }
}


#pragma mark - Object Subscripting

- (id)objectForKeyedSubscript:(id <NSCopying>)key {

    NSString *route = (NSString *)key;
    id obj = nil;
    
    if ([route isKindOfClass:[NSString class]] && [route length]) {
        obj = self.classesByRoute[route];
        if (!obj) {
            obj = self.blocksByRoute[route];
        }
    }
    
    return obj;
}


- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    
    NSString *route = (NSString *)key;
    if (!([route isKindOfClass:[NSString class]] && [route length])) {
        return;
    }
    
    if (!obj) {
        [self.mutableRoutes removeObject:route];
        [self.classesByRoute removeObjectForKey:route];
        [self.blocksByRoute removeObjectForKey:route];
    }
    else if (obj && class_isMetaClass(object_getClass(obj)) && [obj conformsToProtocol:@protocol(BTNDeepLinkRouteHandler)]) {
        [self registerHandlerClass:obj forRoute:route];
    }
    else if ([obj isKindOfClass:NSClassFromString(@"NSBlock")]) {
        [self registerBlock:obj forRoute:route];
    }
}

@end
