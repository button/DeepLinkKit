import UIKit

@UIApplicationMain
class DPLReceiverSwiftAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var router: DPLDeepLinkRouter = DPLDeepLinkRouter()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Route registration.
        self.router["/product/:sku"] = DPLProductRouteHandler.self;
        
        self.router.registerHandlerClass(DPLMessageRouteHandler.self, forRoute: "/say/:title/:message")
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
    {
        self.router.handleURL(url, withCompletion: nil)
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]!) -> Void) -> Bool
    {
        self.router.handleUserActivity(userActivity, withCompletion: nil)
        return true
    }
}

