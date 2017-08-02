import Foundation
import CoreGraphics
import AVFoundation
import CoreMedia

protocol ReorienterProtocol {
    func buildInstructions(assetTrack: AVAssetTrack, compositionAssetTrack: AVCompositionTrack, timeRange: CMTimeRange) -> AVVideoCompositionInstruction
}

class Reorienter: ReorienterProtocol {
    var transformTransformer: TransformTransformerProtocol = TransformTransformer()
    var michaelBay: MichaelBayProtocol = MichaelBay()

    func buildInstructions(assetTrack: AVAssetTrack, compositionAssetTrack: AVCompositionTrack, timeRange: CMTimeRange) -> AVVideoCompositionInstruction {
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionAssetTrack)
        
        var transform: CGAffineTransform!
        transform = assetTrack.preferredTransform
        transform.tx = transformTransformer.newTranslationValue(original: transform.tx, size: assetTrack.naturalSize)
        transform.ty = transformTransformer.newTranslationValue(original: transform.ty, size: assetTrack.naturalSize)
        michaelBay.set(transform: transform, on: layerInstruction, at: kCMTimeZero)        
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.layerInstructions = [layerInstruction]
        instruction.timeRange = timeRange
        
        return instruction
    }
}
