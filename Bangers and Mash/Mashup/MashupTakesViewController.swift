import UIKit
import FontAwesome_swift

class MashupTakesViewController: UIViewController {
    var subviewPresenter: SubviewPresenterProtocol = SubviewPresenter()
    var videoCollectionViewControllerProvider: VideoCollectionViewControllerProviderProtocol = VideoCollectionViewControllerProvider()
    var videoRepository: VideoRepositoryProtocol = VideoRepository()

    @IBOutlet weak var addVideoButton: UIButton!
    @IBOutlet weak var mashupListView: UIView!
    @IBOutlet weak var songLabel: UILabel!

    var videoCollectionViewController: VideoCollectionViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        addVideoButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        addVideoButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)

        songLabel.text = song().name

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cameraViewController = segue.destination as? CameraViewController {
            cameraViewController.configure(song: song())
        }
    }

    private func deleteVideo(url: URL) {
        videoRepository.delete(url: url)
    }

    func song() -> Song {
        let path = Bundle.main.path(forResource: "wild_thoughts", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        return Song(name: "DJ Khaled, Rihanna, Bryson Tiller - Wild Thoughts (Medasin Dance Remix)", url: url, recordingStartTime: 8)
    }
}
