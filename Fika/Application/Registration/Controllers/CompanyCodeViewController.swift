import UIKit

class CompanyCodeViewController: UIViewController {

    var hidesBackButton = false
    var titleText = "Welcome to Fika"

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var companyCode: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
        self.navigationItem.hidesBackButton = hidesBackButton
        titleLabel.text = titleText
    }

}
