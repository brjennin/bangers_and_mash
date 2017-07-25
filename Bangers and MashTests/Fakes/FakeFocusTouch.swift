import UIKit
@testable import Bangers_and_Mash

class FakeFocusTouch: FocusTouchProtocol {
    var capturedPointForShowFocus: CGPoint?
    var capturedViewForShowFocus: UIView?
    func showFocus(at point: CGPoint, in view: UIView) {
        capturedPointForShowFocus = point
        capturedViewForShowFocus = view
    }
}
