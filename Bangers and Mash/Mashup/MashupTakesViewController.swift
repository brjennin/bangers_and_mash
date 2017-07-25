import UIKit
import FontAwesome_swift

class MashupTakesViewController: UIViewController {
    @IBOutlet weak var addVideoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        addVideoButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 50)
        addVideoButton.setTitle(String.fontAwesomeIcon(name: .plusCircle), for: .normal)
    }
}
