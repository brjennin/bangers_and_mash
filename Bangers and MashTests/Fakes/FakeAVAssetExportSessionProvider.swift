import Foundation
import AVFoundation
@testable import Bangers_and_Mash

class FakeAVAssetExportSessionProvider: AVAssetExportSessionProviderProtocol {
    var capturedAssetForGet: AVAsset?
    var capturedQualityForGet: String?
    var returnSessionForGet: AVAssetExportSession!
    func get(asset: AVAsset, quality: String) -> AVAssetExportSession {
        capturedAssetForGet = asset
        capturedQualityForGet = quality
        return returnSessionForGet
    }
}
