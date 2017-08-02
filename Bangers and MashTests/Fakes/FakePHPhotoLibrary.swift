import Foundation
@testable import Bangers_and_Mash

class FakePHPhotoLibrary: PHPhotoLibraryProtocol {
    var capturedChangeBlockForPerformChanges: (() -> ())?
    var capturedCompletionForPerformChanges: ((Bool, Error?) -> ())?
    func performChanges(_ changeBlock: @escaping () -> Void, completionHandler: ((Bool, Error?) -> Void)?) {
        capturedChangeBlockForPerformChanges = changeBlock
        capturedCompletionForPerformChanges = completionHandler
    }
}
