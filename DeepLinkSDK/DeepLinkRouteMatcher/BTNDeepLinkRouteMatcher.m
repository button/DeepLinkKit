#import "BTNDeepLinkRouteMatcher.h"
#import "NSString+BTNTrim.h"

@interface BTNDeepLinkRouteMatcher ()

@property (nonatomic, copy)   NSString *route;
@property (nonatomic, strong) NSArray  *routeParts;

@end

@implementation BTNDeepLinkRouteMatcher

+ (instancetype)matcherWithRoute:(NSString *)route {
    return [[self alloc] initWithRoute:route];
}


- (instancetype)initWithRoute:(NSString *)route {
    if (![route length]) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        _route            = route;
        _routeParts       = [_route componentsSeparatedByString:@"/"];
    }
    
    return self;
}


- (BOOL)matchesPath:(NSString *)path {

    NSString *trimmedPath = [path BTN_trimPath];
    NSArray  *pathParts   = [trimmedPath componentsSeparatedByString:@"/"];
    
    if ([pathParts count] != [self.routeParts count]) {
        return NO;
    }
    
    __block BOOL isMatch = NO;
    [self.routeParts enumerateObjectsUsingBlock:^(NSString *routeComponent, NSUInteger idx, BOOL *stop) {
        NSString *pathComponent = pathParts[idx];
        
        if ([routeComponent rangeOfString:@":"].location == 0) {
            isMatch = YES;
        }
        else if ([pathComponent isEqualToString:routeComponent]) {
            isMatch = YES;
        }
        else {
            isMatch = NO;
            *stop = YES;
        }
    }];
    
    return isMatch;
}

@end
