import Foundation
import AVFoundation
@testable import Bangers_and_Mash

class FakeAVPlayer: AVPlayer {
    var _currentItem: AVPlayerItem?
    override var currentItem: AVPlayerItem? {
        get {
            return _currentItem
        }
        set(newItem) {
            _currentItem = newItem
        }
    }

    var calledPause = false
    override func pause() {
        calledPause = true
    }

    var calledPlay = false
    override func play() {
        calledPlay = true
    }

    var capturedTimeForSeek: CMTime?
    override func seek(to time: CMTime) {
        capturedTimeForSeek = time
    }

    func reset() {
        _currentItem = nil
        calledPlay = false
        calledPause = false
        capturedTimeForSeek = nil
    }
}
