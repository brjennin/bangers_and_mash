import UIKit

protocol VideoCollectionViewControllerProviderProtocol {
    func get() -> VideoCollectionViewController
}

class VideoCollectionViewControllerProvider: VideoCollectionViewControllerProviderProtocol {
    var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

    func get() -> VideoCollectionViewController {
        return storyboard.instantiateViewController(withIdentifier: "VideoCollectionViewController") as! VideoCollectionViewController
    }
}
