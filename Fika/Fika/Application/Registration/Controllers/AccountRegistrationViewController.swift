//
//  AccountRegistrationViewController.swift
//  Fika
//
//  Created by Hanming on 15/6/21.
//

import UIKit

class AccountRegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction private func onBackButtonPressed(_ sender: UIButton) {
        let trans = CATransition()
        trans.type = CATransitionType.moveIn
        trans.subtype = CATransitionSubtype.fromLeft
        trans.duration = 0.35
        self.navigationController?.view.layer.add(trans, forKey: nil)
        navigationController?.popViewController(animated: false)
    }
}
