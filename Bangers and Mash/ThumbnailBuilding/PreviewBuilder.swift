import UIKit
import AVFoundation

protocol PreviewBuilderProtocol {
    func image(for videoURL: URL) -> UIImage?
}

class PreviewBuilder: PreviewBuilderProtocol {
    func image(for videoURL: URL) -> UIImage? {
        let asset = AVURLAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        let image = try? imageGenerator.copyCGImage(at: kCMTimeZero, actualTime: nil)

        if let cgImage = image {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}
