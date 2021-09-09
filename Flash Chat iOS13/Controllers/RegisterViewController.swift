//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import  Firebase
class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    override func viewDidLoad() {
         super.viewDidLoad()
        passwordTextfield.autocorrectionType = .no
     }
    @IBAction func registerPressed(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { (data, error) in
            if let e = error {
                print(e)
            }else {
                self.performSegue(withIdentifier: Constants.registerSegue, sender: self)
            }
        }
    }
}
