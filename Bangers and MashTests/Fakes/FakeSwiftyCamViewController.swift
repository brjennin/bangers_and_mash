import UIKit
import SwiftyCam
@testable import Bangers_and_Mash

class FakeSwiftyCamViewController: UIViewController, SwiftyCamViewControllerProtocol {
    var flashEnabled = false

    var calledStartVideoRecording = false
    func startVideoRecording() {
        calledStartVideoRecording = true
    }

    var calledStopVideoRecording = false
    func stopVideoRecording() {
        calledStopVideoRecording = true
    }

    var calledSwitchCamera = false
    func switchCamera() {
        calledSwitchCamera = true
    }
}
