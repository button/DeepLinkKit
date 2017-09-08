import UIKit

@UIApplicationMain
class DPLReceiverSwiftAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var router: DPLDeepLinkRouter = DPLDeepLinkRouter()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        // Register a class to a route using object subscripting
        self.router["/product/:sku"] = DPLProductRouteHandler.self
        
        // Register a class to a route using the explicit registration call
        self.router.registerHandlerClass(DPLMessageRouteHandler.self, forRoute: "/say/:title/:message")
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        self.router.handle(url, withCompletion: nil)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        self.router.handle(url, withCompletion: nil)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        self.router.handle(userActivity, withCompletion: nil)
        return true
    }
}

