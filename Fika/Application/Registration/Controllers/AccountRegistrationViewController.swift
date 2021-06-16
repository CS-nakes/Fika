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
        emailField.delegate = self
        firstPasswordField.delegate = self
        secondPasswordField.delegate = self
    }

    @IBAction private func onDidTapRegisterButton(_ sender: UIButton) {
        let email = emailField.text!
        let firstPassword = firstPasswordField.text!
        let secondPassword = secondPasswordField.text!

        if firstPassword != secondPassword {
            print("Passwords do not match.")
            return
        }

        FirebaseConnection().createAuth(email: email, password: firstPassword, completion: createAuthCompletion)
    }

    private func createAuthCompletion(authResult: AuthDataResult?, error: Error?) {
        guard let user = authResult?.user, error == nil else {
            print("Error \(error?.localizedDescription ?? "")")
            return
        }

        // Registration successful
        print("User is created successfully!")

    }
}
