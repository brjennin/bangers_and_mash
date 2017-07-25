import UIKit

protocol SubviewPresenterProtocol: class {
    func add(subController: UIViewController, toController: UIViewController, view: UIView)
    func add(subview: UIView, to parentView: UIView)
    func remove(subview: UIView)
}

class SubviewPresenter: SubviewPresenterProtocol {
    func add(subController: UIViewController, toController: UIViewController, view: UIView) {
        let subview = subController.view!
        toController.addChildViewController(subController)
        view.addSubview(subview)

        subview.translatesAutoresizingMaskIntoConstraints = false

        for side in [NSLayoutAttribute.top, NSLayoutAttribute.bottom, NSLayoutAttribute.leading, NSLayoutAttribute.trailing] {
            let constraint = NSLayoutConstraint(item: subview, attribute: side, relatedBy: .equal, toItem: view, attribute: side, multiplier: 1, constant: 0)
            view.addConstraint(constraint)
        }

        subController.didMove(toParentViewController: toController)
    }

    func add(subview: UIView, to parentView: UIView) {
        parentView.addSubview(subview)
    }

    func remove(subview: UIView) {
        subview.removeFromSuperview()
    }
}
