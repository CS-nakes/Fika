import UIKit

/// Fix the following keyboard issues:
/// - Cannot dismiss keyboard
/// - Keyboard blocks textfield
extension UIViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
