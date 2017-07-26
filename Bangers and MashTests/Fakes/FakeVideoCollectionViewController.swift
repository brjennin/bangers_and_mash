import UIKit
@testable import Bangers_and_Mash

class FakeVideoCollectionViewController: VideoCollectionViewController {
    var capturedVideosForLoad: [URL]?
    var capturedDeleteCallbackForLoad: ((URL) -> ())?
    override func load(videos: [URL], deleteCallback: ((URL) -> ())?) {
        capturedVideosForLoad = videos
        capturedDeleteCallbackForLoad = deleteCallback
    }
}
