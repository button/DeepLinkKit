import UIKit

@UIApplicationMain
class DPLReceiverSwiftAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var router: DPLDeepLinkRouter = DPLDeepLinkRouter()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Register a class to a route using object subscripting
        self.router["/product/:sku"] = DPLProductRouteHandler.self
        
        // Register a block (inside a wrapper) to a route using the explicit registration call
        self.router["/say/:title/:message"] = DPLRouteHandlerBlockWrapper(routeHandlerBlock: { (deepLink) -> Void in
            if let title = deepLink.routeParameters["title"] as? String,
                message = deepLink.routeParameters["message"] as? String {
                    UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
            }
        })
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        self.router.handleURL(url, withCompletion: nil)
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]!) -> Void) -> Bool {
        
        self.router.handleUserActivity(userActivity, withCompletion: nil)
        return true
    }
}

