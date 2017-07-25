import UIKit

protocol AnimatorProtocol {
    func animate(withDuration duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions, animations: @escaping () -> (), completion: ((Bool) -> ())?)
}

class Animator: AnimatorProtocol {
    func animate(withDuration duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions, animations: @escaping () -> (), completion: ((Bool) -> ())?) {
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: completion)
    }
}
