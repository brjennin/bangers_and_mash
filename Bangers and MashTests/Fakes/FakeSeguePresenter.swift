import UIKit
@testable import Bangers_and_Mash

class FakeSeguePresenter: SeguePresenterProtocol {
    var capturedControllerForTrigger: UIViewController?
    var capturedIdentifierForTrigger: String?
    func trigger(on controller: UIViewController, identifier: String) {
        capturedControllerForTrigger = controller
        capturedIdentifierForTrigger = identifier
    }
}
