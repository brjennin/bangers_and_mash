import Foundation
import AVFoundation
import CoreGraphics
import CoreMedia

protocol MichaelBayProtocol {
    func set(transform: CGAffineTransform, on instruction: AVMutableVideoCompositionLayerInstruction, at time: CMTime)
}

class MichaelBay: MichaelBayProtocol {
    func set(transform: CGAffineTransform, on instruction: AVMutableVideoCompositionLayerInstruction, at time: CMTime) {
        instruction.setTransform(transform, at: time)
    }
}
