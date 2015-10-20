import UIKit

@UIApplicationMain
class DPLReceiverSwiftAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var router: DPLDeepLinkRouter = DPLDeepLinkRouter()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Register a class to a route using object subscripting
        self.router["/product/:sku"] = DPLProductRouteHandler.self
        
        // Register a block to a route using the explicit registration call
        self.router.registerBlock({ (deepLink) -> Void in
            if let title = deepLink.routeParameters["title"] as? String,
                message = deepLink.routeParameters["message"] as? String {
                    UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
            }
        }, forRoute: "/say/:title/:message")
        
        self.router.route("beers") { [weak self] (deepLink) -> Void in
            if let navController = self?.window?.rootViewController as? UINavigationController,
                beersViewController = navController.storyboard?.instantiateViewControllerWithIdentifier("beers") as? DPLProductTableViewController {
                    navController.pushViewController(beersViewController, animated: false)
            }
        }
        
        self.router.route("test") { 
            return DPLTestViewController()
        }
        
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

