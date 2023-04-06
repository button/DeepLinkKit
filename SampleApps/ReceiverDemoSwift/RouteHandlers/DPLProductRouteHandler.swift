import Foundation

open class DPLProductRouteHandler: DPLRouteHandler {
    open override func targetViewController() -> UIViewController & DPLTargetViewController {
        if let storyboard = UIApplication.shared.keyWindow?.rootViewController?.storyboard {
            return storyboard.instantiateViewController(withIdentifier: "detail") as! DPLProductDetailViewController
        }
        
        return super.targetViewController()!
    }
}
