import Foundation

protocol SchedulerProtocol {
    func fireOnce(after seconds: TimeInterval, block: @escaping (Timer) -> ())
}

class Scheduler: SchedulerProtocol {
    func fireOnce(after seconds: TimeInterval, block: @escaping (Timer) -> ()) {
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: block)
    }
}
