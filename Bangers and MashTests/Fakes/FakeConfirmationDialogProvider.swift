import Foundation
import UIKit
@testable import Bangers_and_Mash

class FakeConfirmationDialogProvider: ConfirmationDialogProviderProtocol {
    var capturedTitle: String?
    var capturedMessage: String?
    var capturedConfirmOption: String?
    var capturedDenyOption: String?
    var capturedController: UIViewController?
    var capturedCompletion: ((Bool) -> ())?
    func buildDialog(title: String, message: String?, confirmOptionTitle: String, denyOptionTitle: String?, controller: UIViewController, completion: @escaping (Bool) -> ()) {
        capturedTitle = title
        capturedMessage = message
        capturedConfirmOption = confirmOptionTitle
        capturedDenyOption = denyOptionTitle
        capturedController = controller
        capturedCompletion = completion
    }
}
