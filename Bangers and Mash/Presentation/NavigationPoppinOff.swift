import UIKit

protocol NavigationPoppinOffProtocol {
    func pop(from navigationController: UINavigationController, animated: Bool)
}

class NavigationPoppinOff: NavigationPoppinOffProtocol {
    func pop(from navigationController: UINavigationController, animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
}
