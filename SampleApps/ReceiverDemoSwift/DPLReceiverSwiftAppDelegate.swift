import UIKit

@UIApplicationMain
class DPLReceiverSwiftAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var router: DPLDeepLinkRouter = DPLDeepLinkRouter()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Register a block to a route (matches dpl:///product/93598)
        self.router.register("/product/:sku") { link in
            print("\(link.url.absoluteString)")
            
            if let rootViewController = application.keyWindow?.rootViewController as? UINavigationController {
                if let storyboard = rootViewController.storyboard {
                    if let controller = storyboard.instantiateViewController(withIdentifier: "detail") as? DPLTargetViewController {
                        controller.configure(with: link)
                        rootViewController.pushViewController(controller as! UIViewController, animated: false)
                    }
                }
            }
        }
        
        self.router.register("/log/:message") { link in
            print("\(String(describing: link.routeParameters["message"]))")
        }
        
        // Register a class to a route.
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

