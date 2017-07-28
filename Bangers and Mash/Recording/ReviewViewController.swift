import UIKit

class ReviewViewController: UIViewController {
    var subviewPresenter: SubviewPresenterProtocol = SubviewPresenter()
    var videoPlayerViewControllerProvider: VideoPlayerViewControllerProviderProtocol = VideoPlayerViewControllerProvider()
    var viewDismisser: ViewDismisserProtocol = ViewDismisser()
    var videoArchiver: VideoArchiverProtocol = VideoArchiver()

    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var keepButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!

    var tempVideoUrl: URL!
    var videoKeptCallback: (() -> ())!
    var videoPlayerController: VideoPlayerViewController!

    func configureWith(videoUrl: URL, videoKeptCallback: @escaping () -> ()) {
        tempVideoUrl = videoUrl
        self.videoKeptCallback = videoKeptCallback
        videoPlayerController = videoPlayerViewControllerProvider.get()
        videoPlayerController.load(videoUrl: videoUrl)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subviewPresenter.add(subController: videoPlayerController, toController: self, view: playerView)
        keepButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        keepButton.setTitle(String.fontAwesomeIcon(name: .thumbsOUp), for: .normal)
        retakeButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        retakeButton.setTitle(String.fontAwesomeIcon(name: .ban), for: .normal)
    }

    @IBAction func didTapKeepTake(_ sender: Any) {
        keepButton.isEnabled = false
        retakeButton.isEnabled = false
        videoArchiver.persist(tempUrl: tempVideoUrl)
        viewDismisser.dismiss(controller: self)
        videoKeptCallback()
    }

    @IBAction func didTapRetake(_ sender: Any) {
        keepButton.isEnabled = false
        retakeButton.isEnabled = false
        viewDismisser.dismiss(controller: self)
    }
}
