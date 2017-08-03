import UIKit
@testable import Bangers_and_Mash

class FakeAlertActionProvider: AlertActionProviderProtocol {
    struct ArgumentsForBuildAction {
        let title: String
        let style: UIAlertActionStyle
        let handler: ((UIAlertAction) -> ())?
    }
    var capturedOptions = [ArgumentsForBuildAction]()
    var returnedActions: [UIAlertAction]!
    func buildAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction) -> ())?) -> UIAlertAction {
        let options = ArgumentsForBuildAction(title: title, style: style, handler: handler)
        capturedOptions.append(options)

        return returnedActions.remove(at: 0)
    }
}
