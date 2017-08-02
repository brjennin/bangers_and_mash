import Foundation
import AVFoundation
@testable import Bangers_and_Mash

class FakeVideoArchiver: VideoArchiverProtocol {
    var capturedTempUrlForPersist: URL?
    func persist(tempUrl: URL) {
        capturedTempUrlForPersist = tempUrl
    }

    var capturedAssetForExportTemp: AVAsset?
    var capturedVideoCompositionForExportTemp: AVVideoComposition?
    var capturedCompletionForExportTemp: ((URL) -> ())?
    func exportTemp(asset: AVAsset, videoComposition: AVVideoComposition, completion: @escaping (URL) -> ()) {
        capturedAssetForExportTemp = asset
        capturedVideoCompositionForExportTemp = videoComposition
        capturedCompletionForExportTemp = completion
    }

    var capturedUrlForDownloadVideoToCameraRoll: URL?
    var capturedCompletionForDownloadVideoToCameraRoll: ((Bool) -> ())?
    func downloadVideoToCameraRoll(url: URL, completion: @escaping (Bool) -> ()) {
        capturedUrlForDownloadVideoToCameraRoll = url
        capturedCompletionForDownloadVideoToCameraRoll = completion
    }
}
