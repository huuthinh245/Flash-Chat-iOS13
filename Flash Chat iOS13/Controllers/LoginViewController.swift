//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController  {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.text = "aaa@gmail.com"
        passwordTextfield.text = "123456"
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        showAlert();
        Auth.auth().signIn(withEmail: emailTextfield.text!, password: passwordTextfield.text!) { [weak self](success, error) in
            if error != nil {
                print(error)
            }
            if let data = success {
                print(data.user.email as Any)
                self?.dismiss(animated: true, completion: {
                        self?.performSegue(withIdentifier: Constants.loginSegue, sender: self)
                })
            }
        }
    }
    deinit {
        print("destroy")
    }
    
    func showAlert () {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}
