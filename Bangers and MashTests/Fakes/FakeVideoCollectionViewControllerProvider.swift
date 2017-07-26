import UIKit
@testable import Bangers_and_Mash

class FakeVideoCollectionViewControllerProvider: VideoCollectionViewControllerProviderProtocol {
    var returnValueForGet: VideoCollectionViewController!
    func get() -> VideoCollectionViewController {
        return returnValueForGet
    }
}
