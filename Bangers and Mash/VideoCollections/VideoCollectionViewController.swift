import UIKit

class VideoCollectionViewController: UITableViewController {
    @IBOutlet weak var footerView: UIView!

    var videos = [URL]()
    var deleteCallback: ((URL, [URL]) -> ())?

    func load(videos: [URL], deleteCallback: ((URL, [URL]) -> ())?) {
        self.videos = videos
        self.deleteCallback = deleteCallback
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

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return deleteCallback != nil
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let deleteCallback = deleteCallback, editingStyle == .delete {
            let video = self.videos.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteCallback(video, videos)
        }
    }
}
