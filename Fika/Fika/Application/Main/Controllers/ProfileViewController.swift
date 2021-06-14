//
//  ProfileViewController.swift
//  Fika
//
//  Created by Cao Wenjie on 14/6/21.
//

import UIKit

class ProfileViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var positionField: UITextField!
    @IBOutlet private weak var introduce: UITextView!
    @IBOutlet private weak var profileImage: UIImageView!

    let imagePicker = UIImagePickerController()

    let textViewPlaceHolder = "Introduce yourself here!"

    override func viewDidLoad() {
        super.viewDidLoad()

        introduce.delegate = self
        introduce.text = textViewPlaceHolder
        introduce.textColor = UIColor.systemGray3
        introduce.layer.borderWidth = 1
        introduce.layer.borderColor = UIColor.systemGray5.cgColor
        introduce.layer.cornerRadius = 6

        imagePicker.delegate = self
    }

    @IBAction func selectImage(_ sender: UIButton) {
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

    func validateProfile() -> Bool {
        !(nameField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)

    }

    @IBAction func onSave(_ sender: UIButton) {
        if validateProfile() {

        } else {
            displayErrors()
        }
    }

    func displayErrors() {

    }
}
