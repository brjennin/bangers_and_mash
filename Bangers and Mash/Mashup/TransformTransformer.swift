import Foundation
import CoreGraphics

protocol TransformTransformerProtocol {
    func newTranslationValue(original: CGFloat, size: CGSize) -> CGFloat
}

class TransformTransformer: TransformTransformerProtocol {
    func newTranslationValue(original: CGFloat, size: CGSize) -> CGFloat {
        if original == size.height - size.width
            || original == size.width - size.height {
            return 0
        }
        return original
    }
}
