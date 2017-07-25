import UIKit
import SwiftyCam
@testable import Bangers_and_Mash

class FakeCameraViewControllerProvider: CameraViewControllerProviderProtocol {
    var capturedDelegateForGet: SwiftyCamViewControllerDelegate?
    var returnedControllerForGet: SwiftyCamViewControllerProtocol!
    func get(delegate: SwiftyCamViewControllerDelegate) -> SwiftyCamViewControllerProtocol {
        capturedDelegateForGet = delegate
        return returnedControllerForGet
    }
}
