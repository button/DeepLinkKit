#import "DeepLinkManager.h"

@implementation DeepLinkManager

+ (instancetype)sharedManager {
    static DeepLinkManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DeepLinkManager alloc] init];
    });
    
    return _manager;
}

@end
