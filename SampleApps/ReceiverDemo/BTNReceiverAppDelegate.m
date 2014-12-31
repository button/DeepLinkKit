#import "BTNReceiverAppDelegate.h"
#import <DeepLinkSDK/DeepLinkSDK.h>

@interface BTNReceiverAppDelegate ()

@property (nonatomic, strong) BTNDeepLinkRouter *router;

@end


@implementation BTNReceiverAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#ifdef TEST
    return YES;
#endif
    
    self.router = [[BTNDeepLinkRouter alloc] init];
    
    self.router[@"/log"] = ^(BTNDeepLink *link) {
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
