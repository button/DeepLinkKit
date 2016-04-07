import Foundation

public class DPLArrayRouteHandler: DPLRouteHandler {
    public override func shouldHandleDeepLink(deepLink: DPLDeepLink!) -> Bool {
        if let list = deepLink["list"] as? Array<String> {
            let alertController = UIAlertController(title: NSLocalizedString("Shopping List", comment: ""),
                                                    message: NSLocalizedString("Please buy the following:", comment: ""),
                                                    preferredStyle: .ActionSheet)
            for title in list {
                alertController.addAction(UIAlertAction(title: title, style: .Default, handler: nil))
            }
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        }
        return false
    }
}