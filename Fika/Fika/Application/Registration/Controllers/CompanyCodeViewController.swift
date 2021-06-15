import UIKit

class CompanyCodeViewController: UIViewController {
    var hidesBackButton = false

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
        self.navigationItem.hidesBackButton = hidesBackButton
    }

}
