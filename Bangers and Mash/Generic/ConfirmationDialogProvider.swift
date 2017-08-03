import UIKit

protocol ConfirmationDialogProviderProtocol: class {
    func buildDialog(title: String, message: String?, confirmOptionTitle: String, denyOptionTitle: String?, controller: UIViewController, completion: @escaping (Bool) -> ())
}

class ConfirmationDialogProvider: ConfirmationDialogProviderProtocol {
    var alertActionProvider: AlertActionProviderProtocol = AlertActionProvider()

    func buildDialog(title: String, message: String?, confirmOptionTitle: String, denyOptionTitle: String?, controller: UIViewController, completion: @escaping (Bool) -> ()) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = alertActionProvider.buildAction(title: confirmOptionTitle, style: .default) { _ in
            completion(true)
        }
        alertController.addAction(confirmAction)

        if let denyOptionTitle = denyOptionTitle {
            let denyAction = alertActionProvider.buildAction(title: denyOptionTitle, style: .default) { _ in
                completion(false)
            }
            alertController.addAction(denyAction)
        }

        controller.present(alertController, animated: true, completion: nil)
    }
}
