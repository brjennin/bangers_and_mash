import Foundation
import AVFoundation
@testable import Bangers_and_Mash

class FakeVideoArchiver: VideoArchiverProtocol {
    var capturedTempUrlForPersist: URL?
    func persist(tempUrl: URL) {
        capturedTempUrlForPersist = tempUrl
    }

    var capturedAssetForExportTemp: AVAsset?
    var capturedCompletionForExportTemp: ((URL) -> ())?
    func exportTemp(asset: AVAsset, completion: @escaping (URL) -> ()) {
        capturedAssetForExportTemp = asset
        capturedCompletionForExportTemp = completion
    }
}
