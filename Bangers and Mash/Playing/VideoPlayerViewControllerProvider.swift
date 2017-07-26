import UIKit

protocol VideoPlayerViewControllerProviderProtocol {
    func get() -> VideoPlayerViewController
}

class VideoPlayerViewControllerProvider: VideoPlayerViewControllerProviderProtocol {
    var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    func get() -> VideoPlayerViewController {
        return storyboard.instantiateViewController(withIdentifier: "VideoPlayerViewController") as! VideoPlayerViewController
    }
}
