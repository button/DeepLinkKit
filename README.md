<p align="center"><img src="https://cloud.githubusercontent.com/assets/1057077/5712062/47dbd414-9a7d-11e4-8829-bd8513bd624b.png" width="204"/>

</p>
<h1 align="center">DeepLink SDK</h1>


<p align="center">
<a href="https://travis-ci.org/usebutton/ios-deeplink-sdk"><img src="http://img.shields.io/travis/usebutton/ios-deeplink-sdk.svg?style=flat" alt="CI Status" /></a>
<a href='https://coveralls.io/r/usebutton/ios-deeplink-sdk'><img src='https://coveralls.io/repos/usebutton/ios-deeplink-sdk/badge.svg' alt='Coverage Status' /></a>
<a href="http://cocoadocs.org/docsets/DeepLinkSDK"><img src="https://img.shields.io/cocoapods/v/DeepLinkSDK.svg?style=flat" alt="Version" /></a>
<a href="http://cocoadocs.org/docsets/DeepLinkSDK"><img src="https://img.shields.io/cocoapods/l/DeepLinkSDK.svg?style=flat" alt="License" /></a>
<a href="http://cocoadocs.org/docsets/DeepLinkSDK"><img src="https://img.shields.io/cocoapods/p/DeepLinkSDK.svg?style=flat" alt="Platform" /></a>
</p>

## Overview

The Button DeepLink SDK is a splendid route-matching, block-based way to handle your deep links. Rather than decide how to format your URLs, parse them, pass data, and navigate to specific content or perform actions, this library and a few lines of code will get you on your way.

[Full Documentation](http://www.usebutton.com/sdk/deep-links/integration-guide)

## Check it out

Try the `DeepLinkSDK` sample project by running the following command:
```ruby
pod try "DeepLinkSDK"
```

## Installation

DeepLinkSDK is available through [CocoaPods](http://cocoapods.org). To install
the library, simply add the following line to your Podfile:
```ruby
pod "DeepLinkSDK"
```


## Usage
Add deep link support to your app in 5 minutes or less following these simple steps.

<em><strong>Note:</strong> As of `0.2.0`, in all registered routes, paths are considered to begin at the first forward slash. A route component before the first forward slash will be considered the host.</em>



<br /><br />
**1. Make sure you have a URL scheme registered for your app in your Info.plist**
<img src="https://cloud.githubusercontent.com/assets/1057077/5710380/8d913f3e-9a6f-11e4-83a2-49f6564d7a8f.png" width="410" />

<br />
**2. Create an instance of `DPLDeepLinkRouter` in your app delegate**

````objc
- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  self.router = [[DPLDeepLinkRouter alloc] init];

  return YES;
}
````
<br />
**3. Register a route handler**

````objc
self.router[@"/log/:message"] = ^(DPLDeepLink *link) {
  NSLog(@"%@", link.routeParameters[@"message"]);
};
````
<br />
**4. Pass incoming URLs to the router**

```objc
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

  [self.router handleURL:url withCompletion:NULL];

  return YES;
}
```
Learn more about the DeepLinkSDK by reading our [Integration Guide](http://www.usebutton.com/sdk/deep-links/integration-guide).

## Route Registration Examples

URLs coming into your app will be in a similar format to the following:
`<scheme>://<host>/<path-component>/<path-component>`

When registering routes, it's important to note that the first forward slash in your registered route determines the start of the path to be matched. A route component before the first forward slash will be considered to be the host.

Say you have an incoming URL of `twitter://timeline`

```objc

// Matches the URL.
router[@"timeline"] = ^{ … }

// Does not match the URL.
router[@"/timeline"] = ^{ … }
```

In another example, a URL of `twitter://dpl.com/timeline`

```objc
// Matches the URL.
router[@"/timeline"] = ^{ … }

// Does not match the URL.
router[@"timeline"] = ^{ … }

```



## Running the Demo

To run the example project, run `pod try DeepLinkSDK` in your terminal. You can also clone the repo, and run `pod install` from the project root. If you don't have CocoaPods, begin by [follow this guide](http://guides.cocoapods.org/using/getting-started.html).

There are two demo apps, `SenderDemo`, and `ReceiverDemo`. `ReceiverDemo` has some registered routes that will handle specific deep links. `SenderDemo` has a couple actions that will deep link out to `ReceiverDemo` for fulfillment.

Run the`SenderDemo` build scheme first, then stop the simulator and switch the build scheme to `ReceiverDemo` and run again. Now you can switch back to the `SenderDemo` app in the simulator and tap on one of the actions.

## Authors

[Wes Smith](http://twitter.com/w5mith)<br />
[Chris Maddern](http://twitter.com/chrismaddern)

## License

DeepLinkSDK is available under the MIT license. See the LICENSE file for more info.

## Contributing

We'd love to see your ideas for improving this library. The best way to contribute is by submitting a pull request. We'll do our best to respond to you as soon as possible. You can also submit a new Github issue if you find bugs or have questions. :octocat:

Please make sure to follow our general coding style and add test coverage for new features!
