import UIKit

class ReviewViewController: UIViewController {
    var subviewPresenter: SubviewPresenterProtocol = SubviewPresenter()
    var videoPlayerViewControllerProvider: VideoPlayerViewControllerProviderProtocol = VideoPlayerViewControllerProvider()

    @IBOutlet weak var playerView: UIView!

    var videoPlayerController: VideoPlayerViewController!

    func configureWith(videoUrl: URL) {
        videoPlayerController = videoPlayerViewControllerProvider.get()
        videoPlayerController.load(videoUrl: videoUrl)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subviewPresenter.add(subController: videoPlayerController, toController: self, view: view)
    }
}
