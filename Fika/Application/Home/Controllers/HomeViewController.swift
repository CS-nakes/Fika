import UIKit

class HomeViewController: UIViewController {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var positionLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()

        // Clear all "past controllers".
        guard let navigationController = self.navigationController else {
            return
        }
        var navigationArray = navigationController.viewControllers
        let temp = navigationArray.last
        navigationArray.removeAll()
        navigationArray.append(temp!)
        self.navigationController?.viewControllers = navigationArray
    }

}
