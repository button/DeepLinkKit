import UIKit

public class DPLInventoryRouteHandler: DPLRouteHandler {
    public override func preferAsynchronous() -> Bool {
        return true
    }
    
    public override func targetViewControllerWithCompletion(completionHandler: ((UIViewController!) -> Void)!) {
        guard let storyboard = UIApplication.sharedApplication().keyWindow?.rootViewController?.storyboard else {
            completionHandler(nil)
            return
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            let vc = storyboard.instantiateViewControllerWithIdentifier("inventory") as! DPLInventoryTableViewController
            completionHandler(vc)
        }
    }
}
