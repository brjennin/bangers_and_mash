import Foundation
import AVFoundation
import CoreGraphics
import CoreMedia
@testable import Bangers_and_Mash

class FakeMichaelBay: MichaelBayProtocol {
    var capturedTransformForSet: CGAffineTransform?
    var capturedInstructionForSet: AVMutableVideoCompositionLayerInstruction?
    var capturedTimeForSet: CMTime?
    func set(transform: CGAffineTransform, on instruction: AVMutableVideoCompositionLayerInstruction, at time: CMTime) {
        capturedTransformForSet = transform
        capturedInstructionForSet = instruction
        capturedTimeForSet = time
    }
}
