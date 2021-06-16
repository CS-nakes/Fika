import UIKit

class HomeViewController: UIViewController {

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
