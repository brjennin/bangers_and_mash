import Foundation
import AVFoundation
@testable import Bangers_and_Mash

class FakeTrackStar: TrackStarProtocol {
    var capturedAssetForAudioTrack: AVAsset?
    var returnAssetTrackForAudioTrack: AVAssetTrack!
    func audioTrack(from asset: AVAsset) -> AVAssetTrack {
        capturedAssetForAudioTrack = asset
        return returnAssetTrackForAudioTrack
    }

    var capturedAssetForVideoTrack: AVAsset?
    var returnAssetTrackForVideoTrack: AVAssetTrack!
    func videoTrack(from asset: AVAsset) -> AVAssetTrack {
        capturedAssetForVideoTrack = asset
        return returnAssetTrackForVideoTrack
    }

    struct ArgumentsForAdd {
        let capturedTrack: AVAssetTrack
        let capturedCompositionTrack: AVMutableCompositionTrack
        let capturedRange: CMTimeRange
        let capturedTime: CMTime
    }
    var capturedArgumentsForAdd = [ArgumentsForAdd]()
    func add(track: AVAssetTrack, to compositionTrack: AVMutableCompositionTrack, for range: CMTimeRange, at time: CMTime) {
        capturedArgumentsForAdd.append(ArgumentsForAdd(capturedTrack: track, capturedCompositionTrack: compositionTrack, capturedRange: range, capturedTime: time))
    }
}
