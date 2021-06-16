import UIKit

class ProfileViewController: UIViewController, UITextViewDelegate,
                             UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet private var nameField: UITextField!
    @IBOutlet private var positionField: UITextField!
    @IBOutlet private var introduce: UITextView!
    @IBOutlet private var profileImage: UIImageView!
    @IBOutlet private var continueButton: UIButton!

    var user = User()

    let imagePicker = UIImagePickerController()

    let textViewPlaceHolder = "Introduce yourself here!"

    override func viewDidLoad() {
        super.viewDidLoad()

        nameField.text = user.name
        positionField.text = user.position
        introduce.text = user.introduction

        validateFields()

        introduce.delegate = self

        if introduce.text == nil {
            introduce.text = textViewPlaceHolder
            introduce.textColor = UIColor.systemGray3
        }

        introduce.layer.borderWidth = 1
        introduce.layer.borderColor = UIColor.systemGray5.cgColor
        introduce.layer.cornerRadius = 6

        imagePicker.delegate = self
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

    func textViewDidBeginEditing(_ textView: UITextView) {

        if introduce.textColor == UIColor.systemGray3 {
            introduce.text = ""
            introduce.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {

        if introduce.text.isEmpty {

            introduce.text = textViewPlaceHolder
            introduce.textColor = UIColor.systemGray3
        }
    }

//    @IBAction func onContinue(_ sender: UIButton) {
//        user = User(name: nameField.text, position: positionField.text, introduction: introduce.text)
//
//
//
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        user = User(name: nameField.text, position: positionField.text, introduction: introduce.text)
        if segue.identifier == "toTimeSlot" {
            guard let nextController = segue.destination as? TimingViewController else {
                return
            }

            nextController.user = user
        }
    }

    @IBAction private func unwindToPresentingViewController(segue: UIStoryboardSegue) {
        print("unwind")
        if segue.identifier == "backToProfile" {
            guard let controller = segue.source as? TimingViewController else {
                return
            }

            user = User(name: controller.user.name, position: controller.user.position, companyId: controller.user.companyId,
                        introduction: controller.user.introduction,
                        profilePicture: controller.user.profilePicture, preferredTimeslots: controller.selectedSlots)

            print(user.preferredTimeslots)

        }
    }

    @IBAction private func onNameEditingEnd(_ sender: UITextField) {
        validateFields()
    }

    @IBAction private func onPositionEditingEnd(_ sender: UITextField) {
        validateFields()
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
