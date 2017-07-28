import Foundation
import AVFoundation
import CoreMedia

protocol TrackStarProtocol {
    func audioTrack(from asset: AVAsset) -> AVAssetTrack
    func videoTrack(from asset: AVAsset) -> AVAssetTrack
    func add(track: AVAssetTrack, to compositionTrack: AVMutableCompositionTrack, for range: CMTimeRange, at time: CMTime)
}

class TrackStar: TrackStarProtocol {
    func audioTrack(from asset: AVAsset) -> AVAssetTrack {
        return asset.tracks(withMediaType: AVMediaTypeAudio).first!
    }

    func videoTrack(from asset: AVAsset) -> AVAssetTrack {
        return asset.tracks(withMediaType: AVMediaTypeVideo).first!
    }

    func add(track: AVAssetTrack, to compositionTrack: AVMutableCompositionTrack, for range: CMTimeRange, at time: CMTime) {
        try! compositionTrack.insertTimeRange(range, of: track, at: time)
    }
}
