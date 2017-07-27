import Foundation
import AVFoundation
@testable import Bangers_and_Mash

class FakeAVAudioPlayer: AVAudioPlayer {
    var _isPlaying = false
    override var isPlaying: Bool {
        get {
            return _isPlaying
        }
        set(newItem) {
            _isPlaying = newItem
        }
    }

    var _currentTime: TimeInterval = 0
    override var currentTime: TimeInterval {
        get {
            return _currentTime
        }
        set (newItem) {
            _currentTime = newItem
        }
    }

    var calledPrepareToPlay = false
    override func prepareToPlay() -> Bool {
        calledPrepareToPlay = true
        return true
    }

    var calledPlay = false
    override func play() -> Bool {
        calledPlay = true
        return true
    }

    var capturedTimeForPlayAt: TimeInterval?
    override func play(atTime time: TimeInterval) -> Bool {
        capturedTimeForPlayAt = time
        return true
    }

    var calledStop = false
    override func stop() {
        calledStop = true
    }

    func reset() {
        currentTime = 0
        _isPlaying = false
        calledPrepareToPlay = false
        calledPlay = false
        capturedTimeForPlayAt = nil
        calledStop = false
    }
}
