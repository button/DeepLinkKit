import Foundation

open class DPLMessageRouteHandler: DPLRouteHandler {
    open override func shouldHandle(_ deepLink: DPLDeepLink!) -> Bool {
        if let title = deepLink.routeParameters["title"] as? String,
            let message = deepLink.routeParameters["message"] as? String {
            UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
        }
        return false
    }
}
