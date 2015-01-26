import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var router: DPLDeepLinkRouter!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        router = DPLDeepLinkRouter()
        
        router.registerRoute("/say/:title/:message", routeHandler: { (link) in
            println(link.routeParameters["title"])
        })
        
        return true
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        router.handleURL(url, withCompletion: nil)
        
        return true
    }
}

