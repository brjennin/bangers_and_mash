import UIKit
import SwiftyCam

class CameraViewController: UIViewController {
    var cameraViewControllerProvider: CameraViewControllerProviderProtocol = CameraViewControllerProvider()
    var subviewPresenter: SubviewPresenterProtocol = SubviewPresenter()
    var ballDrop: BallDropProtocol = BallDrop()
    var animator: AnimatorProtocol = Animator()
    var scheduler: SchedulerProtocol = Scheduler()
    var seguePresenter: SeguePresenterProtocol = SeguePresenter()

    static let countdownTime = 3
    static let videoDuration: TimeInterval = 15

    @IBOutlet weak var cameraContainer: UIView!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var captureButton: RecordButton!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!

    var swiftyCamController: SwiftyCamViewControllerProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        swiftyCamController = cameraViewControllerProvider.get(delegate: self)
        subviewPresenter.add(subController: swiftyCamController as! UIViewController, toController: self, view: cameraContainer)
    }

    @IBAction func didTapCapture(_ sender: RecordButton) {
        captureButton.isEnabled = false
        countdownLabel.text = "\(CameraViewController.countdownTime)"
        countdownLabel.isHidden = false

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
            flashButton.imageView?.image = #imageLiteral(resourceName: "flash")
        } else {
            flashButton.imageView?.image = #imageLiteral(resourceName: "flashOutline")
        }
    }

    @IBAction func didSwitchCamera(_ sender: UIButton) {
        swiftyCamController.switchCamera()
    }

    private func showRecordingStarted() {
        self.countdownLabel.isHidden = true
        self.swiftyCamController.startVideoRecording()
        self.captureButton.indicateRecording()
        self.animator.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.flashButton.alpha = 0
            self?.flipCameraButton.alpha = 0
            }, completion: nil)
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
        animator.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self?.flashButton.alpha = 1
            self?.flipCameraButton.alpha = 1
            }, completion: nil)
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {

        //        let reviewViewController = ReviewViewController(videoURL: url)
        //        self.present(reviewViewController, animated: true, completion: nil)
    }

    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        //        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        //        focusView.center = point
        //        focusView.alpha = 0.0
        //        view.addSubview(focusView)
        //
        //        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
        //            focusView.alpha = 1.0
        //            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        //        }, completion: { (success) in
        //            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
        //                focusView.alpha = 0.0
        //                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
        //            }, completion: { (success) in
        //                focusView.removeFromSuperview()
        //            })
        //        })
    }
}
