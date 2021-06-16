import UIKit
import Firebase

class AccountRegistrationViewController: UIViewController {
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var firstPasswordField: UITextField!
    @IBOutlet private var secondPasswordField: UITextField!
    @IBOutlet private var topConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
        emailField.delegate = self
        firstPasswordField.delegate = self
        secondPasswordField.delegate = self

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction private func onDidTapRegisterButton(_ sender: UIButton) {
        let email = emailField.text!
        let firstPassword = firstPasswordField.text!
        let secondPassword = secondPasswordField.text!

        if firstPassword != secondPassword {
            print("Passwords do not match.")
            return
        }

        FirebaseConnection().createAuth(email: email, password: firstPassword, completion: createAuthCompletion)
    }

    private func createAuthCompletion(authResult: AuthDataResult?, error: Error?) {
        guard authResult?.user != nil, error == nil else {
            print("Error \(error?.localizedDescription ?? "")")
            return
        }
        // Registration successful
        print("User is created successfully!")

        performSegue(withIdentifier: "ToProfile", sender: nil)
    }

    @objc
    func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }

        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration: TimeInterval =
            (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)

        if endFrameY >= UIScreen.main.bounds.size.height {
            // Keyboard down
            topConstraint.constant = 65
        } else {
            // Keyboard up
            topConstraint.constant = 30
        }

        UIView.animate(
            withDuration: duration,
            delay: TimeInterval(0),
            options: animationCurve,
            animations: { self.view.layoutIfNeeded() },
            completion: nil
        )
    }
}
