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
        [[[UIAlertView alloc] initWithTitle:link[@"title"]
                                    message:link[@"message"]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    };
    
    __weak __typeof__(self) weakSelf = self;
    self.router[@"beers"] = ^{
        UINavigationController *navController = (UINavigationController *)weakSelf.window.rootViewController;
        UIViewController *controller = [navController.storyboard instantiateViewControllerWithIdentifier:@"beers"];
        [navController pushViewController:controller animated:NO];
    };

    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
 
    return [self.router handleURL:url userInfo:nil withCompletion:NULL];
}

@end
