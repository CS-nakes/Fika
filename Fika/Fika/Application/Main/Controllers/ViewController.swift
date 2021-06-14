//
//  ViewController.swift
//  Fika
//
//  Created by Hanming on 14/6/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }

    @IBAction func onPress(_ sender: UIButton) {
        performSegue(withIdentifier: "createProfile", sender: self)
    }

}
