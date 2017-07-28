import UIKit
import SwiftyCam

class CameraViewController: UIViewController {
    var cameraViewControllerProvider: CameraViewControllerProviderProtocol = CameraViewControllerProvider()
    var subviewPresenter: SubviewPresenterProtocol = SubviewPresenter()
    var ballDrop: BallDropProtocol = BallDrop()
    var animator: AnimatorProtocol = Animator()
    var scheduler: SchedulerProtocol = Scheduler()
    var seguePresenter: SeguePresenterProtocol = SeguePresenter()
    var focusTouch: FocusTouchProtocol = FocusTouch()
    var navigationPoppinOff: NavigationPoppinOffProtocol = NavigationPoppinOff()
    var songPlayer: SongPlayerProtocol = SongPlayer()
    var youreJustMashingIt: YoureJustMashingItProtocol = YoureJustMashingIt()

    static let countdownTime = 3

    @IBOutlet weak var cameraContainer: UIView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var captureButton: RecordButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!

    var swiftyCamController: SwiftyCamViewControllerProtocol!
    var lastVideoUrl: URL?
    var song: Song!

    func configure(song: Song) {
        self.song = song
        songPlayer.load(song: song)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        swiftyCamController = cameraViewControllerProvider.get(delegate: self)
        subviewPresenter.add(subController: swiftyCamController as! UIViewController, toController: self, view: cameraContainer)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reviewViewController = segue.destination as? ReviewViewController {
            reviewViewController.configureWith(videoUrl: lastVideoUrl!, videoKeptCallback: { [weak self] in
                if let weakSelf = self {
                    weakSelf.navigationPoppinOff.pop(from: weakSelf.navigationController!, animated: false)
                }
            })
        }
    }

    @IBAction func didTapCapture(_ sender: RecordButton) {
        flashButton.isEnabled = false
        flipCameraButton.isEnabled = false
        captureButton.isEnabled = false
        countdownLabel.text = "\(CameraViewController.countdownTime)"
        countdownLabel.isHidden = false

        self.animator.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.flashButton.alpha = 0
            self?.flipCameraButton.alpha = 0
            }, completion: nil)

        let timeToDrop = TimeInterval(exactly: CameraViewController.countdownTime)!
        songPlayer.playSong(fromCountdown: timeToDrop)
        ballDrop.start(dropTime: timeToDrop, secondsLeftCallback: { [weak self] timeLeft in
            if timeLeft > 0 {
                self?.countdownLabel.text = "\(timeLeft)"
            } else {
                self?.showRecordingStarted()
            }
        })
    }

    @IBAction func didToggleFlash(_ sender: UIButton) {
        swiftyCamController.flashEnabled = !swiftyCamController.flashEnabled
        if swiftyCamController.flashEnabled {
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: .normal)
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: .normal)
        }
    }

    @IBAction func didSwitchCamera(_ sender: UIButton) {
        swiftyCamController.switchCamera()
    }

    private func showRecordingStarted() {
        self.countdownLabel.isHidden = true
        self.swiftyCamController.startVideoRecording()
        self.captureButton.indicateRecording()
    }
}

extension CameraViewController: SwiftyCamViewControllerDelegate {
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        _ = scheduler.fireOnce(after: song.recordDuration, block: { [weak self] timer in
            self?.swiftyCamController.stopVideoRecording()
        })
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        captureButton.indicateRecordingFinished()
        captureButton.isEnabled = true
        flashButton.isEnabled = true
        flipCameraButton.isEnabled = true
        songPlayer.stopSong()
        animator.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.flashButton.alpha = 1
            self?.flipCameraButton.alpha = 1
            }, completion: nil)
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        youreJustMashingIt.combine(song: song, videoUrl: url) { [weak self] url in
            if let weakSelf = self {
                weakSelf.lastVideoUrl = url
                weakSelf.seguePresenter.trigger(on: weakSelf, identifier: "reviewVideo")
            }
        }
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        focusTouch.showFocus(at: point, in: swiftyCamController.view)
    }
}
