import Foundation
@testable import Bangers_and_Mash

class FakeScheduler: SchedulerProtocol {
    var capturedSecondsForFireOnce: TimeInterval?
    var capturedBlockForFireOnce: ((Timer) -> ())?
    var returnTimerForFireOnce: Timer!
    func fireOnce(after seconds: TimeInterval, block: @escaping (Timer) -> ()) -> Timer {
        capturedSecondsForFireOnce = seconds
        capturedBlockForFireOnce = block

        return returnTimerForFireOnce
    }

    var capturedSecondsForFireRepeatedly: TimeInterval?
    var capturedBlockForFireRepeatedly: ((Timer) -> ())?
    var returnTimerForFireRepeatedly: Timer!
    func fireRepeatedly(every seconds: TimeInterval, block: @escaping (Timer) -> ()) -> Timer {
        capturedSecondsForFireRepeatedly = seconds
        capturedBlockForFireRepeatedly = block

        return returnTimerForFireRepeatedly
    }
}
