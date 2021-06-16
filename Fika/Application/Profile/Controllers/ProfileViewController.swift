import UIKit

class ProfileViewController: UIViewController, UITextViewDelegate,
                             UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var positionField: UITextField!
    @IBOutlet private var introductionField: TextField!
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var continueButton: UIButton!
    @IBOutlet private var topConstraint: NSLayoutConstraint!

    var selectedImage: UIImage?

    var user = User()

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()

        nameField.text = user.name
        nameField.delegate = self
        positionField.text = user.position
        positionField.delegate = self
        introductionField.text = user.introduction
        introductionField.delegate = self
        if selectedImage == nil {
            // swiftlint:disable:next object_literal
            profileImage.image = UIImage(named: "profile")
        } else {
            profileImage.image = selectedImage
        }

        imagePicker.delegate = self

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    @IBAction private func selectImage(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFill
            profileImage.image = pickedImage
            selectedImage = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        user.introduction = introductionField.text
        if let nextController = segue.destination as? TimingViewController {
            nextController.user = user
            nextController.image = selectedImage
        }
    }

    func validateProfile() -> Bool {
        !(nameField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
    }

    @IBAction private func onNameEditingEnd(_ sender: UITextField) {
        user.name = nameField.text
    }

    @IBAction private func onPositionEditingEnd(_ sender: UITextField) {
        user.position = positionField.text
    }

    func areFieldsValid() -> Bool {
        guard let name = nameField.text, let position = positionField.text else {
            return false
        }
        return !name.trimmingCharacters(in: .whitespaces).isEmpty &&
            !position.trimmingCharacters(in: .whitespaces).isEmpty
    }

    @IBAction private func onContinueDidPress(_ sender: UIButton) {
        if !areFieldsValid() {
            return
        }
        performSegue(withIdentifier: "ToTimeSlots", sender: nil)
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
            self.navigationItem.setHidesBackButton(false, animated: true)
        } else {
            // Keyboard up
            topConstraint.constant = -30
            self.navigationItem.setHidesBackButton(true, animated: true)
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
