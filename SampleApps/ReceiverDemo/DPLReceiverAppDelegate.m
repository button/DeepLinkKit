#import "DPLReceiverAppDelegate.h"
#import "DPLProductRouteHandler.h"

@import DeepLinkKit;

@interface DPLReceiverAppDelegate ()

@property (nonatomic, strong) DPLDeepLinkRouter *router;

@end


@implementation DPLReceiverAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

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

    self.router[@"shoppinglist/:list"] = ^(DPLDeepLink *link) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Shopping List", nil)
                                                                             message:NSLocalizedString(@"Please buy the following:", nil)
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *title in link[@"list"]) {
            [actionSheet addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:NULL]];
        }
        [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:NULL]];
        UIViewController *rootViewController = weakSelf.window.rootViewController;
        if ([rootViewController.presentedViewController isKindOfClass:[UIAlertController class]]) {
            [rootViewController dismissViewControllerAnimated:NO completion:NULL];
        }
        [rootViewController presentViewController:actionSheet animated:YES completion:NULL];
    };

    return YES;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
 
    return [self.router handleURL:url withCompletion:NULL];
}


- (BOOL)application:(UIApplication *)application
        continueUserActivity:(NSUserActivity *)userActivity
    restorationHandler:(void (^)(NSArray *))restorationHandler {
    
    return [self.router handleUserActivity:userActivity withCompletion:NULL];
}

@end
