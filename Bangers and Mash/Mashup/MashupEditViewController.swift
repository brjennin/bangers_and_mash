import UIKit

class MashupEditViewController: UIViewController {
    var subviewPresenter: SubviewPresenterProtocol = SubviewPresenter()
    var videoPlayerViewControllerProvider: VideoPlayerViewControllerProviderProtocol = VideoPlayerViewControllerProvider()
    var youreJustMashingIt: YoureJustMashingItProtocol = YoureJustMashingIt()
    var dispatcher: DispatcherProtocol = Dispatcher()

    var videos: [URL]!
    var song: Song!

    @IBOutlet weak var playerView: UIView!

    func configure(videos: [URL], song: Song) {
        self.videos = videos
        self.song = song
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        youreJustMashingIt.randomMash(song: song, videoUrls: videos) { [weak self] url in
            if let weakSelf = self {
                let videoPlayerController = weakSelf.videoPlayerViewControllerProvider.get()
                videoPlayerController.load(videoUrl: url)
                weakSelf.dispatcher.dispatchToMainQueue {
                    weakSelf.subviewPresenter.add(subController: videoPlayerController, toController: weakSelf, view: weakSelf.playerView)
                }
            }
        }
    }
}



