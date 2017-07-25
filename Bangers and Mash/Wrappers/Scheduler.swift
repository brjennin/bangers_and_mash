import Foundation

protocol SchedulerProtocol {
    func fireOnce(after seconds: TimeInterval, block: @escaping (Timer) -> ())

    func fireRepeatedly(every seconds: TimeInterval, block: @escaping (Timer) -> ()) -> Timer
}

class Scheduler: SchedulerProtocol {
    func fireOnce(after seconds: TimeInterval, block: @escaping (Timer) -> ()) {
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: block)
    }

    func fireRepeatedly(every seconds: TimeInterval, block: @escaping (Timer) -> ()) -> Timer {
        return Timer.scheduledTimer(withTimeInterval: seconds, repeats: true, block: block)
    }
}
