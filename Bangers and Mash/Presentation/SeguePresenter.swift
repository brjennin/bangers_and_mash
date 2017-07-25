import UIKit

protocol SeguePresenterProtocol {
    func trigger(on controller: UIViewController, identifier: String)
}

class SeguePresenter: SeguePresenterProtocol {
    func trigger(on controller: UIViewController, identifier: String) {
        controller.performSegue(withIdentifier: identifier, sender: nil)
    }
}
