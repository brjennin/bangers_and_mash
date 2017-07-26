import UIKit
@testable import Bangers_and_Mash

class FakeViewDismisser: ViewDismisserProtocol {
    var capturedControllerForDismiss: UIViewController?
    func dismiss(controller: UIViewController) {
        capturedControllerForDismiss = controller
    }
}
