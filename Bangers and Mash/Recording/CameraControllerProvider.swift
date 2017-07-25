import UIKit
import SwiftyCam

protocol SwiftyCamViewControllerProtocol {
    var flashEnabled: Bool { get set }
    var view: UIView! { get set }

    func startVideoRecording()
    func stopVideoRecording()
    func switchCamera()
}
extension SwiftyCamViewController: SwiftyCamViewControllerProtocol {}

protocol CameraViewControllerProviderProtocol {
    func get(delegate: SwiftyCamViewControllerDelegate) -> SwiftyCamViewControllerProtocol
}

class CameraViewControllerProvider: CameraViewControllerProviderProtocol {
    func get(delegate: SwiftyCamViewControllerDelegate) -> SwiftyCamViewControllerProtocol {
        let controller = SwiftyCamViewController()
        controller.cameraDelegate = delegate
        controller.shouldUseDeviceOrientation = true
        controller.allowAutoRotate = false
        controller.defaultCamera = .front
        controller.swipeToZoom = false
        controller.allowBackgroundAudio = false
        controller.audioEnabled = false
        controller.lowLightBoost = false

        return controller
    }
}
