import Foundation

protocol RandomPickerProtocol {
    func pick<T>(from list: [T]) -> T
}

class RandomPicker: RandomPickerProtocol {
    func pick<T>(from list: [T]) -> T {
        let randomIndex = Int(arc4random_uniform(UInt32(list.count)))
        return list[randomIndex]
    }
}
