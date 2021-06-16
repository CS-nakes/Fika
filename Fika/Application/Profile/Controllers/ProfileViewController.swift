import UIKit

class ProfileViewController: UIViewController, UITextViewDelegate,
                             UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var positionField: UITextField!
    @IBOutlet private var introductionField: TextField!
    @IBOutlet private var profileImage: UIImageView!

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        introductionField.contentVerticalAlignment = .top
    }

    @IBAction private func selectImage(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFit
            profileImage.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func validateProfile() -> Bool {
        !(nameField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)

    }

    @IBAction private func onSave(_ sender: UIButton) {
        if validateProfile() {

        } else {
            displayErrors()
        }
    }

    func displayErrors() {

    }
}
