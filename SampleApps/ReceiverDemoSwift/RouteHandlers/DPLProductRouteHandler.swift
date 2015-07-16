import Foundation

public class DPLProductRouteHandler: DPLRouteHandler {
    public override func targetViewController() -> UIViewController! {
        if let storyboard = UIApplication.sharedApplication().keyWindow?.rootViewController?.storyboard {
            return storyboard.instantiateViewControllerWithIdentifier("detail") as! DPLProductDetailViewController
        }
        
        return UIViewController()
    }
}