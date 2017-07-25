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

    static let countdownTime = 3
    static let videoDuration: TimeInterval = 15

    @IBOutlet weak var cameraContainer: UIView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var captureButton: RecordButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!

    var swiftyCamController: SwiftyCamViewControllerProtocol!
    var lastVideoUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        swiftyCamController = cameraViewControllerProvider.get(delegate: self)
        subviewPresenter.add(subController: swiftyCamController as! UIViewController, toController: self, view: cameraContainer)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let reviewViewController = segue.destination as? ReviewViewController {
            reviewViewController.configureWith(videoUrl: lastVideoUrl!)
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
        scheduler.fireOnce(after: CameraViewController.videoDuration, block: { [weak self] timer in
            self?.swiftyCamController.stopVideoRecording()
        })
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        captureButton.indicateRecordingFinished()
        captureButton.isEnabled = true
        flashButton.isEnabled = true
        flipCameraButton.isEnabled = true
        animator.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.flashButton.alpha = 1
            self?.flipCameraButton.alpha = 1
            }, completion: nil)
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        lastVideoUrl = url
        seguePresenter.trigger(on: self, identifier: "reviewVideo")
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        focusTouch.showFocus(at: point, in: swiftyCamController.view)
    }
}
