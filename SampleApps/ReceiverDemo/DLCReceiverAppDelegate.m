#import "DLCReceiverAppDelegate.h"
#import <DeepLinkSDK/DeepLinkSDK.h>

@interface DLCReceiverAppDelegate ()

@property (nonatomic, strong) DLCDeepLinkRouter *router;

@end


@implementation DLCReceiverAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#ifdef TEST
    return YES;
#endif
    
    self.router = [[DLCDeepLinkRouter alloc] init];
    
    self.router[@"/log"] = ^(DLCDeepLink *link) {
        NSLog(@"%@", link.appLinkData[DLCAppLinkExtrasKey]);
    };
    
    [self.router handleURL:launchOptions[UIApplicationLaunchOptionsURLKey] withCompletion:NULL];

    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
 
    [self.router handleURL:url withCompletion:NULL];
    
    return YES;
}

@end
