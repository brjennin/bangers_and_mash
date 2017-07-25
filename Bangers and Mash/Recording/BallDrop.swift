import UIKit

protocol BallDropProtocol {
    func start(dropTime: TimeInterval, secondsLeftCallback: @escaping (Int) -> ())
}

class BallDrop: BallDropProtocol {
    var scheduler: SchedulerProtocol = Scheduler()

    func start(dropTime: TimeInterval, secondsLeftCallback: @escaping (Int) -> ()) {

    }
}
