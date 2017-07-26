import UIKit
@testable import Bangers_and_Mash

class FakeNavigationPoppinOff: NavigationPoppinOffProtocol {
    var capturedNavControllerForPop: UINavigationController?
    var capturedAnimatedForPop: Bool?
    func pop(from navigationController: UINavigationController, animated: Bool) {
        capturedNavControllerForPop = navigationController
        capturedAnimatedForPop = animated
    }
}
