import UIKit
@testable import Bangers_and_Mash

class FakeMashupEditViewController: MashupEditViewController {
    var capturedVideosForConfigure: [URL]?
    override func configure(videos: [URL]) {
        capturedVideosForConfigure = videos
    }
}
