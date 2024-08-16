import UIKit

class BlurLoadingView {
    
    private var blurEffectView: UIVisualEffectView?
    private var activityIndicator: UIActivityIndicatorView?
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func show() {
        guard let viewController = viewController else { return }
        
        // Create and configure the blur effect view
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = viewController.view.bounds
        blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.view.addSubview(blurEffectView!)
        
        // Create and configure the activity indicator
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator?.center = viewController.view.center
        activityIndicator?.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        viewController.view.addSubview(activityIndicator!)
        
        // Start animating the activity indicator
        activityIndicator?.startAnimating()
    }
    
    func hide() {
        // Stop the activity indicator and remove the blur effect view
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        blurEffectView?.removeFromSuperview()
    }
}
