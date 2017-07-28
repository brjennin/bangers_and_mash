import Foundation
import AVFoundation
@testable import Bangers_and_Mash

class FakeAVAssetExportSession: AVAssetExportSession {
    var _status: AVAssetExportSessionStatus = .unknown
    override var status: AVAssetExportSessionStatus {
        get {
            return _status
        }
        set(newItem) {
            _status = newItem
        }
    }

    var capturedCompletionForExportAsync: (() -> ())?
    override func exportAsynchronously(completionHandler handler: @escaping () -> Void) {
        capturedCompletionForExportAsync = handler
    }
}
