import UIKit

protocol FocusTouchProtocol {
    func showFocus(at point: CGPoint, in view: UIView)
}

class FocusTouch: FocusTouchProtocol {
    static let focusAnimationDurationIn: TimeInterval = 0.25
    static let focusAnimationDurationOut: TimeInterval = 0.15
    static let focusAnimationDelayOut: TimeInterval = 0.5

    var animator: AnimatorProtocol = Animator()
    var subviewPresenter: SubviewPresenterProtocol = SubviewPresenter()

    func showFocus(at point: CGPoint, in view: UIView) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        subviewPresenter.add(subview: focusView, to: view)

        animator.animate(withDuration: FocusTouch.focusAnimationDurationIn, delay: 0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { [weak self] _ in
            self?.animator.animate(withDuration: FocusTouch.focusAnimationDurationOut, delay: FocusTouch.focusAnimationDelayOut, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { [weak self] _ in
                self?.subviewPresenter.remove(subview: focusView)
            })
        })
    }
}
