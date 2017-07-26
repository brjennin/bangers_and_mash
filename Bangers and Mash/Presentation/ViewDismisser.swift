import UIKit

protocol ViewDismisserProtocol: class {
    func dismiss(controller: UIViewController)
}

class ViewDismisser: ViewDismisserProtocol {
    func dismiss(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
