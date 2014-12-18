#import "BTNReceiverAppDelegate.h"
#import <DeepLinkSDK/BTNDeepLinkManager.h>

@interface BTNReceiverAppDelegate ()

@property (nonatomic, strong) BTNDeepLinkManager *deepLinkManager;

@end


@implementation BTNReceiverAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.deepLinkManager = [[BTNDeepLinkManager alloc] init];
    self.deepLinkManager[@"table/book/1234"] = ^{
        NSLog(@"deep link");
    };
    
    [self.deepLinkManager handleDeepLink:launchOptions[UIApplicationLaunchOptionsURLKey]
                       completionHandler:NULL];
    
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
