import UIKit
import FontAwesome_swift

class MashupTakesViewController: UIViewController {
    var subviewPresenter: SubviewPresenterProtocol = SubviewPresenter()
    var videoCollectionViewControllerProvider: VideoCollectionViewControllerProviderProtocol = VideoCollectionViewControllerProvider()
    var videoRepository: VideoRepositoryProtocol = VideoRepository()

    @IBOutlet weak var addVideoButton: UIButton!
    @IBOutlet weak var mashupListView: UIView!

    var videoCollectionViewController: VideoCollectionViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        addVideoButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        addVideoButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
        videoCollectionViewController = videoCollectionViewControllerProvider.get()
        subviewPresenter.add(subController: videoCollectionViewController, toController: self, view: mashupListView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        videoRepository.getVideos() { [weak self] videos in
            if let weakSelf = self {
                weakSelf.videoCollectionViewController.load(videos: videos, deleteCallback: weakSelf.deleteVideo)
            }
        }
    }

    private func deleteVideo(url: URL) {
        videoRepository.delete(url: url)
    }
}
