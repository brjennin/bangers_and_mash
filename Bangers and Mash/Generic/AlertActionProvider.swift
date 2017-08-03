import UIKit

protocol AlertActionProviderProtocol: class {
    func buildAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction) -> ())?) -> UIAlertAction
}

class AlertActionProvider: AlertActionProviderProtocol {
    func buildAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction) -> ())?) -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: handler)
    }
}
