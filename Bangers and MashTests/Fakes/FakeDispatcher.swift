import Foundation
@testable import Bangers_and_Mash

class FakeDispatcher: DispatcherProtocol {
    var capturedCompletionForDispatchToMainQueue: (() -> ())?
    func dispatchToMainQueue(completion: @escaping (() -> ())) {
        capturedCompletionForDispatchToMainQueue = completion
    }
}
