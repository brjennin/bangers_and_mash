import UIKit
@testable import Bangers_and_Mash

class FakeAnimator: AnimatorProtocol {

    var capturedDurationForAnimate: TimeInterval?
    var capturedDelayForAnimate: TimeInterval?
    var capturedOptionsForAnimate: UIViewAnimationOptions?
    var capturedAnimationsForAnimate: (() -> ())?
    var capturedCompletionForAnimate: ((Bool) -> ())?
    func animate(withDuration duration: TimeInterval, delay: TimeInterval, options: UIViewAnimationOptions, animations: @escaping () -> (), completion: ((Bool) -> ())?) {
        capturedDurationForAnimate = duration
        capturedDelayForAnimate = delay
        capturedOptionsForAnimate = options
        capturedAnimationsForAnimate = animations
        capturedCompletionForAnimate = completion
    }

    func reset() {
        capturedDurationForAnimate = nil
        capturedDelayForAnimate = nil
        capturedOptionsForAnimate = nil
        capturedAnimationsForAnimate = nil
        capturedCompletionForAnimate = nil
    }
}
