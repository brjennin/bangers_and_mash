import Foundation

protocol DispatcherProtocol: class {
    func dispatchToMainQueue(completion: @escaping (() -> ()))
}

class Dispatcher: DispatcherProtocol {
    var mainQueue = OperationQueue.main

    func dispatchToMainQueue(completion: @escaping (() -> ())) {
        self.mainQueue.addOperation(completion)
    }
}
