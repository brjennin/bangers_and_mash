import Foundation
@testable import Bangers_and_Mash

class FakeScheduler: SchedulerProtocol {
    var capturedSecondsForFireOnce: TimeInterval?
    var capturedBlockForFireOnce: ((Timer) -> ())?
    func fireOnce(after seconds: TimeInterval, block: @escaping (Timer) -> ()) {
        capturedSecondsForFireOnce = seconds
        capturedBlockForFireOnce = block
    }
}
