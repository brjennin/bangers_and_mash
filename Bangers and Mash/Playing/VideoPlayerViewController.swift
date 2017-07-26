import UIKit
import AVFoundation
import AVKit

class VideoPlayerViewController: UIViewController {
    var avPlayerProvider: AVPlayerProviderProtocol = AVPlayerProvider()
    var subviewPresenter: SubviewPresenterProtocol = SubviewPresenter()
    var notificationCenter: NotificationCenterProtocol = NotificationCenter.default

    var player: AVPlayer!
    var playerController: AVPlayerViewController!

    func load(videoUrl: URL) {
        player = avPlayerProvider.get(url: videoUrl)

        playerController = AVPlayerViewController()
        playerController.showsPlaybackControls = false
        playerController.player = player
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subviewPresenter.add(subController: playerController, toController: self, view: view)
        notificationCenter.addObserver(self, selector: #selector(didReachEnd(_:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        player.play()
    }

    @objc func didReachEnd(_ notification: Notification) {
        player.seek(to: kCMTimeZero)
        player.play()
    }
}
