import UIKit
@testable import Bangers_and_Mash

class FakeVideoPlayerViewController: VideoPlayerViewController {
    var capturedUrlForLoad: URL?
    override func load(videoUrl: URL) {
        capturedUrlForLoad = videoUrl
    }
}
