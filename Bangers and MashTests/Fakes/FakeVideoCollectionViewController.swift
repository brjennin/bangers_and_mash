import UIKit
@testable import Bangers_and_Mash

class FakeVideoCollectionViewController: VideoCollectionViewController {
    var capturedVideosForLoad: [URL]?
    override func load(videos: [URL]) {
        capturedVideosForLoad = videos
    }
}
