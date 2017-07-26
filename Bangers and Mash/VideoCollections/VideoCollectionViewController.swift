import UIKit

class VideoCollectionViewController: UITableViewController {
    @IBOutlet weak var footerView: UIView!

    var videos = [URL]()

    func load(videos: [URL]) {
        self.videos = videos
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = footerView
        tableView.estimatedRowHeight = 120
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.configure(video: videos[indexPath.row])
        return cell
    }
}
