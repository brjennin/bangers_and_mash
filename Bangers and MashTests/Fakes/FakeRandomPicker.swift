import UIKit
@testable import Bangers_and_Mash

class FakeRandomPicker: RandomPickerProtocol {
    var capturedListsForPick = [Any]()
    var returnItemsForPick: [Any]!
    func pick<T>(from list: [T]) -> T {
        capturedListsForPick.append(list)
        return returnItemsForPick.remove(at: 0) as! T
    }
}
