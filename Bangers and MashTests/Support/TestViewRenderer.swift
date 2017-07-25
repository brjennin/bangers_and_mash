import UIKit

class TestViewRenderer {
    static func initiateViewLifeCycle(controller: UIViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
