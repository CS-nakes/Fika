import UIKit
import Firebase

class LoginPageViewController: UIViewController {

    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()

        emailField.delegate = self
        passwordField.delegate = self
    }

    @IBAction private func onDidTapLoginButton(_ sender: UIButton) {
        let email = emailField.text!
        let password = passwordField.text!

        FirebaseConnection().signIn(email: email, password: password, completion: signInCompletion)
    }

    private func signInCompletion(authResult: AuthDataResult?, error: Error?) {
        guard let strongSelf = authResult else {
            return
        }

        // Login unsuccessful
        if error != nil {
            // TODO: create an alert here
            print("Login unsuccessful. Please check your email and/or password.")
            return
        }

        // Login successful
        // TODO: transition to another page and persist user data?
        print("Login successful for email!")
        performSegue(withIdentifier: "ToHome", sender: nil)
    }

}
