import UIKit
import Firebase

class LoginPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
    }

    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var passwordField: UITextField!

    @IBAction private func onDidTapLoginButton(_ sender: UIButton) {
        let email = emailField.text!
        let password = passwordField.text!

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let strongSelf = self else { return }

            // Login unsuccessful
            if error != nil {
                // TODO: create an alert here
                print("Login unsuccessful. Please check your email and/or password.")
                return
            }

            // Login successful
            // TODO: transition to another page and persist user data?
            print("Login successful for email \(email)!")
        }

    }
}
