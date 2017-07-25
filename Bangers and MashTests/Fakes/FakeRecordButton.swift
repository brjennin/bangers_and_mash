import UIKit
@testable import Bangers_and_Mash

class FakeRecordButton: RecordButton {
    var calledIndicateRecording = false
    override func indicateRecording() {
        calledIndicateRecording = true
    }

    var calledIndicateRecordingFinished = false
    override func indicateRecordingFinished() {
        calledIndicateRecordingFinished = true
    }
}
