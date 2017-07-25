import UIKit

protocol BallDropProtocol {
    func start(dropTime: TimeInterval, secondsLeftCallback: @escaping (Int) -> ())
}

class BallDrop: BallDropProtocol {
    var scheduler: SchedulerProtocol = Scheduler()

    var timeLeft: Int!

    func start(dropTime: TimeInterval, secondsLeftCallback: @escaping (Int) -> ()) {
        timeLeft = Int(dropTime)
        secondsLeftCallback(timeLeft)
        _ = scheduler.fireRepeatedly(every: 1, block: { [weak self] timer in
            if let weakSelf = self {
                weakSelf.timeLeft = weakSelf.timeLeft - 1
                secondsLeftCallback(weakSelf.timeLeft)

                if weakSelf.timeLeft == 0 {
                    timer.invalidate()
                }
            }
        })
    }
}
