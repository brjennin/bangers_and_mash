import Foundation
import Photos

protocol CameraRollSaverProtocol {
    func saveVideo(url: URL)
}

class CameraRollSaver: CameraRollSaverProtocol {
    func saveVideo(url: URL) {
        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
    }
}
