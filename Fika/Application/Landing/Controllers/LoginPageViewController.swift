import UIKit
import Firebase

class LoginPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
    }

    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!

    @IBAction func onDidTapLoginButton(_ sender: UIButton) {
        let email = emailField.text!
        let password = passwordField.text!

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
          guard let strongSelf = self else {
            return

          }

            if error != nil {
                print("ERROR")
                return
            }

            print("Success")
        }

    }
}
