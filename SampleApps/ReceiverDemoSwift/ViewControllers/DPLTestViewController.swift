import Foundation

public class DPLTestViewController: UIViewController, DPLTargetViewController
{
    public func configureWithDeepLink(deepLink: DPLDeepLink!) {
        // do things
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.whiteColor()
        let label = UILabel(frame: self.view.bounds)
        label.text = "Test View Controller"
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
    }
}