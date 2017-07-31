import UIKit
import FontAwesome_swift

class MashupTakesViewController: UIViewController {
    var subviewPresenter: SubviewPresenterProtocol = SubviewPresenter()
    var videoCollectionViewControllerProvider: VideoCollectionViewControllerProviderProtocol = VideoCollectionViewControllerProvider()
    var videoRepository: VideoRepositoryProtocol = VideoRepository()

    @IBOutlet weak var mashButton: UIButton!
    @IBOutlet weak var addVideoButton: UIButton!
    @IBOutlet weak var mashupListView: UIView!
    @IBOutlet weak var songLabel: UILabel!

    var videoCollectionViewController: VideoCollectionViewController!
    var videos = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addVideoButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        addVideoButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
        mashButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        mashButton.setTitle(String.fontAwesomeIcon(name: .random), for: .normal)

        songLabel.text = song().name

        videoCollectionViewController = videoCollectionViewControllerProvider.get()
        subviewPresenter.add(subController: videoCollectionViewController, toController: self, view: mashupListView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        videoRepository.getVideos() { [weak self] videos in
            if let weakSelf = self {
                weakSelf.videos = videos
                weakSelf.videoCollectionViewController.load(videos: videos, deleteCallback: weakSelf.deleteVideo)
                weakSelf.mashButton.isEnabled = videos.count > 0
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cameraViewController = segue.destination as? CameraViewController {
            cameraViewController.configure(song: song())
        } else if let mashupEditController = segue.destination as? MashupEditViewController {
            mashupEditController.configure(videos: videos, song: song())
        }
    }

    private func deleteVideo(url: URL, videos: [URL]) {
        videoRepository.delete(url: url)
        self.videos = videos
        mashButton.isEnabled = videos.count > 0
    }

    func song() -> Song {
        let path = Bundle.main.path(forResource: "wild_thoughts", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        return Song(name: "DJ Khaled, Rihanna, Bryson Tiller - Wild Thoughts (Medasin Dance Remix)", url: url, recordingStartTime: 8, recordingEndTime: 10)
    }
}
