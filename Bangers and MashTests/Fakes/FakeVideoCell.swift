import UIKit
@testable import Bangers_and_Mash

class FakeVideoCell: VideoCell {
    var capturedVideoForConfigure: URL?
    override func configure(video: URL) {
        capturedVideoForConfigure = video
    }
}
