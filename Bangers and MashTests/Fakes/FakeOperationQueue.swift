import Foundation
@testable import Bangers_and_Mash

class FakeOperationQueue: OperationQueue {
    var completion: (() -> ())?
    override func addOperation(_ block: @escaping () -> Void) {
        completion = block
    }
}
