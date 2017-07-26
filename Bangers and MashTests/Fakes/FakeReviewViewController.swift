import UIKit
@testable import Bangers_and_Mash

class FakeReviewViewController: ReviewViewController {
    var capturedVideoUrlForConfigure: URL?
    var capturedVideoKeptCallbackForConfigure: (() -> ())?
    override func configureWith(videoUrl: URL, videoKeptCallback: @escaping () -> ()) {
        capturedVideoUrlForConfigure = videoUrl
        capturedVideoKeptCallbackForConfigure = videoKeptCallback
    }
}
