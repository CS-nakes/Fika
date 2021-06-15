import UIKit

class LandingPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registrationViewController = segue.destination as? CompanyCodeViewController {
            registrationViewController.titleText = "Sign Up"
        }
    }

}
