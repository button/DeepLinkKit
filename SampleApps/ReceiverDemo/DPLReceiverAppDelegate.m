#import "DPLReceiverAppDelegate.h"
#import "DPLProductRouteHandler.h"

#import <DeepLinkSDK/DeepLinkSDK.h>

@interface DPLReceiverAppDelegate ()

@property (nonatomic, strong) DPLDeepLinkRouter *router;

@end


@implementation DPLReceiverAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
#ifdef TEST
    return YES;
#endif
    
    self.router = [[DPLDeepLinkRouter alloc] init];
   
    // Route registration.
    self.router[@"/product/:sku"] = [DPLProductRouteHandler class];
    
    self.router[@"/say/:title/:message"] = ^(DPLDeepLink *link) {
        [[[UIAlertView alloc] initWithTitle:link.routeParameters[@"title"]
                                    message:link.routeParameters[@"message"]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    };

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
