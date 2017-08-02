import Foundation
import CoreGraphics
import AVFoundation
import CoreMedia
@testable import Bangers_and_Mash

class FakeReorienter: ReorienterProtocol {
    struct ArgumentsForBuildInstructions {
        let assetTrack: AVAssetTrack
        let compositionAssetTrack: AVCompositionTrack
        let timeRange: CMTimeRange
    }
    var capturedArgsForBuildInstructions = [ArgumentsForBuildInstructions]()
    var returnInstructionsForBuildInstructions: [AVVideoCompositionInstruction]!
    func buildInstructions(assetTrack: AVAssetTrack, compositionAssetTrack: AVCompositionTrack, timeRange: CMTimeRange) -> AVVideoCompositionInstruction {
        let args = ArgumentsForBuildInstructions(assetTrack: assetTrack, compositionAssetTrack: compositionAssetTrack, timeRange: timeRange)
        capturedArgsForBuildInstructions.append(args)
        return returnInstructionsForBuildInstructions.remove(at: 0)
    }
}
