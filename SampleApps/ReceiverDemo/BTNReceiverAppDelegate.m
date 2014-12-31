#import "BTNReceiverAppDelegate.h"
#import <DeepLinkSDK/BTNDeepLinkManager.h>
#import <DeepLinkSDK/BTNDeepLink.h>

@interface BTNReceiverAppDelegate ()

@property (nonatomic, strong) BTNDeepLinkManager *deepLinkManager;

@end


@implementation BTNReceiverAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.deepLinkManager = [[BTNDeepLinkManager alloc] init];
    
    self.deepLinkManager[@"/log"] = ^(BTNDeepLink *link) {
        NSLog(@"%@", link.customData[@"message"]);
    };
#ifdef TEST
    return YES;
#endif
    
    __weak __typeof__(self) weakSelf = self;
    self.deepLinkManager[@"/background"] = ^(NSDictionary *params, BTNDeepLink *deepLink) {
        UIViewController *controller = weakSelf.window.rootViewController;
        if ([controller conformsToProtocol:@protocol(BTNDeepLinkTarget)]) {
            [(id)controller configureWithDeepLink:deepLink];
        }
    };
    
    
    if (launchOptions[UIApplicationLaunchOptionsURLKey]) {
        [self.deepLinkManager handleDeepLink:launchOptions[UIApplicationLaunchOptionsURLKey]
                           completionHandler:NULL];
    }

    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
 
    [self.deepLinkManager handleDeepLink:url
                       completionHandler:NULL];
    
    return YES;
}

@end
