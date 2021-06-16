import UIKit

class CompanyCodeViewController: UIViewController {

    var hidesBackButton = false
    var titleText = "Welcome to Fika"

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var companyCodeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
        if hidesBackButton {
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
        titleLabel.text = titleText
        companyCodeTextField.delegate = self
    }
    
    @IBAction func onContinueDidPress(_ sender: UIButton) {
        // TODO: Validation + Logic
        performSegue(withIdentifier: "ToRegistration", sender: nil)
    }
    

}
