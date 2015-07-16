import Foundation

public class DPLMessageRouteHandler: DPLRouteHandler {
    public override func shouldHandleDeepLink(deepLink: DPLDeepLink!) -> Bool {
        if let title = deepLink.routeParameters["title"] as? String,
            message = deepLink.routeParameters["message"] as? String {
            UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
        }
        return false
    }
}
