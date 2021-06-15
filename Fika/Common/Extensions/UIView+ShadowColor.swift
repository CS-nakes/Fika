import UIKit

// Adapted from https://stackoverflow.com/a/35372901
@IBDesignable extension UIView {
    /* The color of the shadow. Defaults to opaque black. Colors created
    * from patterns are currently NOT supported. Animatable. */
    @IBInspectable var dropShadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
        set {
            layer.shadowColor = newValue!.cgColor
        }
    }
}
