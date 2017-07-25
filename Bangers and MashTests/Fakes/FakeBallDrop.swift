import Foundation
@testable import Bangers_and_Mash

class FakeBallDrop: BallDropProtocol {
    var capturedDropTimeForStart: TimeInterval?
    var capturedSecondsLeftCallbackForStart: ((Int) -> ())?
    func start(dropTime: TimeInterval, secondsLeftCallback: @escaping (Int) -> ()) {
        capturedDropTimeForStart = dropTime
        capturedSecondsLeftCallbackForStart = secondsLeftCallback
    }
}
