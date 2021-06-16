import UIKit

class ProfileViewController: UIViewController, UITextViewDelegate,
                             UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var positionField: UITextField!
    @IBOutlet private var introductionField: TextField!
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var continueButton: UIButton!

    var selectedImage: UIImage?

    var user = User()

    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.text = user.name
        nameField.delegate = self
        positionField.text = user.position
        positionField.delegate = self
        introductionField.text = user.introduction
        introductionField.delegate = self
        if selectedImage == nil {
            profileImage.image = UIImage(named: "profile")
        } else {
            profileImage.image = selectedImage
        }

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
    
    
    @IBAction func onContinueDidPress(_ sender: UIButton) {
        if !areFieldsValid() {
            return
        }
        performSegue(withIdentifier: "ToTimeSlots", sender: nil)
    }
}
