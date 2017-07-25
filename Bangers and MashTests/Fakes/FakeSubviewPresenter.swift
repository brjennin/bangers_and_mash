import UIKit
@testable import Bangers_and_Mash

class FakeSubviewPresenter: SubviewPresenterProtocol {
    var capturedSubControllerForAdd: UIViewController?
    var capturedParentControllerForAdd: UIViewController?
    var capturedSuperViewForAdd: UIView?
    func add(subController: UIViewController, toController: UIViewController, view: UIView) {
        capturedSubControllerForAdd = subController
        capturedParentControllerForAdd = toController
        capturedSuperViewForAdd = view
    }
}
