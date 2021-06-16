import UIKit

class ProfileViewController: UIViewController, UITextViewDelegate,
                             UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var positionField: UITextField!
    @IBOutlet private var introductionField: TextField!
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var continueButton: UIButton!

    var user = User()

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = user.name
        positionField.text = user.position
        introductionField.text = user.introduction
        validateFields()

        imagePicker.delegate = self
        introductionField.contentVerticalAlignment = .top
        hideNavBar()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        user.introduction = introductionField.text
        if let nextController = segue.destination as? TimingViewController {
            nextController.user = user
        }
    }

    func validateProfile() -> Bool {
        !(nameField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
    }

    @IBAction private func onNameEditingEnd(_ sender: UITextField) {
        validateFields()
        user.name = nameField.text
    }

    @IBAction private func onPositionEditingEnd(_ sender: UITextField) {
        validateFields()
        user.position = positionField.text
    }

    func validateFields() {
        if nameField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false ||
            positionField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false {
            continueButton.isHidden = true
        } else {
            continueButton.isHidden = false
        }
    }

}
