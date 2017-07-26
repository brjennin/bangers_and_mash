import UIKit

class VideoCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    func configure(video: URL) {
        titleLabel.text = video.lastPathComponent.components(separatedBy: ".").first
    }
}
