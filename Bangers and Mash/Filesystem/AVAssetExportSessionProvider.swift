import Foundation
import AVFoundation

protocol AVAssetExportSessionProviderProtocol {
    func get(asset: AVAsset, quality: String) -> AVAssetExportSession
}

class AVAssetExportSessionProvider: AVAssetExportSessionProviderProtocol {
    func get(asset: AVAsset, quality: String) -> AVAssetExportSession {
        return AVAssetExportSession(asset: asset, presetName: quality)!
    }
}
