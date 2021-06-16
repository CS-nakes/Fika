//
//  AccountRegistrationViewController.swift
//  Fika
//
//  Created by Hanming on 15/6/21.
//

import UIKit
import Firebase

class AccountRegistrationViewController: UIViewController {
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var firstPasswordField: UITextField!
    @IBOutlet private var secondPasswordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavBar()
    }

    @IBAction private func onDidTapRegisterButton(_ sender: UIButton) {
        let email = emailField.text!
        let firstPassword = firstPasswordField.text!
        let secondPassword = secondPasswordField.text!

        if firstPassword != secondPassword {
            print("Passwords do not match.")
            return
        }

        Auth.auth().createUser(withEmail: email, password: firstPassword) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("Error \(error?.localizedDescription ?? "")")
                return
            }

            // Registration successful
            print("User is created successfully!")

            // Transition to home

            // Send user id, email, and company to firestore

        }

    }
}
