import UIKit
@testable import Bangers_and_Mash

class FakeCameraViewController: CameraViewController {
    var capturedSongForConfigure: Song?
    override func configure(song: Song) {
        capturedSongForConfigure = song
    }
}
