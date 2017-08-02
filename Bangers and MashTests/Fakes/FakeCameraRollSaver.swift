import Foundation
import Photos
@testable import Bangers_and_Mash

class FakeCameraRollSaver: CameraRollSaverProtocol {
    var capturedUrlForSaveVideo: URL?
    func saveVideo(url: URL) {
        capturedUrlForSaveVideo = url
    }
}
