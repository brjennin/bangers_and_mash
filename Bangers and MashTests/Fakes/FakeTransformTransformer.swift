import Foundation
import CoreGraphics
@testable import Bangers_and_Mash

class FakeTransformTransformer: TransformTransformerProtocol {
    struct ArgumentsForNewTranslation {
        let original: CGFloat
        let size: CGSize
    }
    var capturedArgumentsForNewTranslation = [ArgumentsForNewTranslation]()
    var returnTranslationsForNewTranslation: [CGFloat]!
    func newTranslationValue(original: CGFloat, size: CGSize) -> CGFloat {
        let arguments = ArgumentsForNewTranslation(original: original, size: size)
        capturedArgumentsForNewTranslation.append(arguments)
        return returnTranslationsForNewTranslation.remove(at: 0)
    }
}
