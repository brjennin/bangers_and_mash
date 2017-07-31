import UIKit
@testable import Bangers_and_Mash

class FakeMashupEditViewController: MashupEditViewController {
    var capturedVideosForConfigure: [URL]?
    var capturedSongForConfigure: Song?
    override func configure(videos: [URL], song: Song) {
        capturedVideosForConfigure = videos
        capturedSongForConfigure = song
    }
}
