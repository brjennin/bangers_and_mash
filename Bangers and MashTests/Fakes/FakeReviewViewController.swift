import UIKit
@testable import Bangers_and_Mash

class FakeReviewViewController: ReviewViewController {
    var capturedVideoUrlForConfigure: URL?
    override func configureWith(videoUrl: URL) {
        capturedVideoUrlForConfigure = videoUrl
    }
}
