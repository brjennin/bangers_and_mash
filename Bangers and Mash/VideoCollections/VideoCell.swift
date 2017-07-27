import UIKit

class VideoCell: UITableViewCell {
    var previewBuilder: PreviewBuilderProtocol = PreviewBuilder()

    @IBOutlet weak var videoThumbImageView: UIImageView!

    func configure(video: URL) {
        videoThumbImageView.image = previewBuilder.image(for: video)
    }
}
