import UIKit
@testable import Bangers_and_Mash

class FakeVideoPlayerViewControllerProvider: VideoPlayerViewControllerProviderProtocol {
    var returnValueForGet: VideoPlayerViewController!
    func get() -> VideoPlayerViewController {
        return returnValueForGet
    }
}
