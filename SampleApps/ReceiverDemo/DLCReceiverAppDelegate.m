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
    
    self.router[@"/say/:title/:message"] = ^(DLCDeepLink *link) {
        [[[UIAlertView alloc] initWithTitle:link.routeParameters[@"title"]
                                    message:link.routeParameters[@"message"]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
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
