import UIKit
@testable import Bangers_and_Mash

class FakePreviewBuilder: PreviewBuilderProtocol {
    var capturedUrlForImage: URL?
    var returnImageForImage: UIImage?
    func image(for videoURL: URL) -> UIImage? {
        capturedUrlForImage = videoURL
        return returnImageForImage
    }
}
