# DeepLinkSDK

[![CI Status](http://img.shields.io/travis/usebutton/ios-deeplink-sdk.svg?style=flat)](https://travis-ci.org/sebutton/ios-deeplink-sdk)
[![Version](https://img.shields.io/cocoapods/v/ios-deeplink-sdk.svg?style=flat)](http://cocoadocs.org/docsets/ios-deeplink-sdk)
[![License](https://img.shields.io/cocoapods/l/ios-deeplink-sdk.svg?style=flat)](http://cocoadocs.org/docsets/ios-deeplink-sdk)
[![Platform](https://img.shields.io/cocoapods/p/ios-deeplink-sdk.svg?style=flat)](http://cocoadocs.org/docsets/ios-deeplink-sdk)


## Overview

The Button DeepLink SDK is a splendid route-matching, block-based way to handle your deep links. Rather than decide how to format your URLs, parse them, pass data, and navigate to specific content or perform actions, this SDK and a few lines of code will get you on your way.

## Usage

Add deep link support to your app in 5 minutes or less following these simple steps.

#####1. Make sure you have a URL scheme registered for your app in your Info.plist:
<img src="https://cloud.githubusercontent.com/assets/1057077/5710380/8d913f3e-9a6f-11e4-83a2-49f6564d7a8f.png" width="410" />


#####2. Create an instance of `DPLDeepLinkRouter` in `application:didFinishLaunchingWithOptions:`

````objc
self.router = [[DPLDeepLinkRouter alloc] init];
````

#####3. Register a route handler:

````objc
self.router[@"log/:message"] = ^(DPLDeepLink *link) {
    NSLog(@"%@", link.routeParameters[@"message"]);
};
````

#####4. Pass incoming URLs to the router:

````objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.router = [[DPLDeepLinkRouter alloc] init];
    self.router[@"log/:message"] = ^(DPLDeepLink *link) {
        NSLog(@"%@", link.routeParameters[@"message"]);
    };

    NSURL *incomingURL = launchOptions[UIApplicationLaunchOptionsURLKey];
    [self.router handleURL:incomingURL withCompletion:NULL];

    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

  [self.router handleURL:url withCompletion:NULL];
}
````
Learn more about the DeepLinkSDK by reading our [Integration Guide](http://www.usebutton.com/sdk/deep-links).


## Examples

To run the example project, clone the repo, and run `pod install` from the Example directory first.

There are two demo apps, `SenderDemo`, and `ReceiverDemo`. `ReceiverDemo` has some registered routes that will handle specific deep links. `SenderDemo` has a couple actions that will deep link out to `ReceiverDemo` for fulfillment.

Run the`SenderDemo` build scheme first, then stop the simulator and switch the build scheme to `ReceiverDemo` and run again. Now you can switch back to the `SenderDemo` app in the simulator and tap on one of the actions.

## Installation

DeepLinkSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "DeepLinkSDK"

## Author

Button, Inc.

## License

DeepLinkSDK is available under the MIT license. See the LICENSE file for more info.

## Contributing

We'd love to see your ideas for improving this library. The best way to contribute is by submitting a pull request. We'll do our best to respond to you as soon as possible. You can also submit a new Github issue if you find bugs or have questions. :octocat:

Please make sure to follow our general coding style and add test coverage for new features!
