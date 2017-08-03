import UIKit
import FontAwesome_swift

class MashupEditViewController: UIViewController {
    var subviewPresenter: SubviewPresenterProtocol = SubviewPresenter()
    var videoPlayerViewControllerProvider: VideoPlayerViewControllerProviderProtocol = VideoPlayerViewControllerProvider()
    var youreJustMashingIt: YoureJustMashingItProtocol = YoureJustMashingIt()
    var dispatcher: DispatcherProtocol = Dispatcher()
    var videoArchiver: VideoArchiverProtocol = VideoArchiver()
    var confirmationDialogProvider: ConfirmationDialogProviderProtocol = ConfirmationDialogProvider()

    var videos: [URL]!
    var song: Song!
    var mostRecentMashUrl: URL?

    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var saveButton: UIButton!

    func configure(videos: [URL], song: Song) {
        self.videos = videos
        self.song = song
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        saveButton.setTitle(String.fontAwesomeIcon(name: .floppyO), for: .normal)
        saveButton.isEnabled = false

        youreJustMashingIt.randomMash(song: song, videoUrls: videos) { [weak self] url in
            if let weakSelf = self {
                let videoPlayerController = weakSelf.videoPlayerViewControllerProvider.get()
                videoPlayerController.load(videoUrl: url)
                weakSelf.dispatcher.dispatchToMainQueue {
                    weakSelf.mostRecentMashUrl = url
                    weakSelf.saveButton.isEnabled = true
                    weakSelf.subviewPresenter.add(subController: videoPlayerController, toController: weakSelf, view: weakSelf.playerView)
                }
            }
        }
    }

    @IBAction func didTapSaveButton(_ sender: UIButton) {
        if let url = mostRecentMashUrl {
            saveButton.isEnabled = false

            videoArchiver.downloadVideoToCameraRoll(url: url) { [weak self] wasSuccessful in
                if let weakSelf = self {
                    weakSelf.saveButton.isEnabled = true
                    
                    var title: String!
                    var message: String!
                    var confirmOption: String!
                    if wasSuccessful {
                        title = "Success!"
                        message = "Video was saved to your camera roll."
                        confirmOption = "OK!"
                    } else {
                        title = "Error!"
                        message = "Video could not be saved. Please try again."
                        confirmOption = "OK"
                    }
                    weakSelf.confirmationDialogProvider.buildDialog(title: title, message: message, confirmOptionTitle: confirmOption, denyOptionTitle: nil, controller: weakSelf) { _ in }
                }
            }
        }
    }
}
