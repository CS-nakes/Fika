import UIKit

/// Adapted from https://stackoverflow.com/a/27066764
class TextField: UITextField {

    let padding = UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
