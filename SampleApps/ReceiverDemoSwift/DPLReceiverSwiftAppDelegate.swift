import UIKit

@UIApplicationMain
class DPLReceiverSwiftAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var router: DPLDeepLinkRouter = DPLDeepLinkRouter()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Register a class to a route using object subscripting
        self.router["/product/:sku"] = DPLProductRouteHandler.self
        
        // Register a class to a route using the explicit registration call
        self.router.registerHandlerClass(DPLMessageRouteHandler.self, forRoute: "/say/:title/:message")
        
        // Register a class to route using an asynchronous target view controller request
        self.router["/inventory"] = DPLInventoryRouteHandler.self
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        self.router.handleURL(url, withCompletion: nil)
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        self.router.handleURL(url, withCompletion: nil)
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        self.router.handleUserActivity(userActivity, withCompletion: nil)
        return true
    }
}

