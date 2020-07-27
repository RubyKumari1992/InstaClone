//
//  ViewController.swift
//  InstaClone
//
//  Created by Ruby Mahto on 30/05/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    // MARK:- Outlets
    
    @IBOutlet weak private var emailField: UITextField!
    @IBOutlet weak private var passwordField: UITextField!
    
    @IBOutlet weak private var loginButton: UIButton!
    
    @IBOutlet weak private var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.hidesBarsOnTap = true
    }
    
    class func instaintateViewControllerFromStoryboard() -> LoginViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyboard.instantiateViewController(identifier: "LoginViewController") as? LoginViewController
        return loginController
    }
    
    // MARK:- Actions
    @IBAction func loginPressed(_ sender: Any) {
        if self.emailField.text != "" && self.passwordField.text != "" {
            Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { (authData, error) in
                if error != nil {
                    self.makeAnAlert(title: "Error!", Description: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toFeed", sender: nil)
                }
            }
        } else {
            self.makeAnAlert(title: "Error", Description: "Please enter Email/Passwod")
        }
    }
    
    @IBAction func registerUser(_ sender: Any) {
        if self.emailField.text != "" && self.passwordField.text != "" {
            
            Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!) { (authData, error) in
                
                if error != nil {
                    self.makeAnAlert(title: "Error Occured", Description: error?.localizedDescription ?? "Error")
                    
                } else {
                    self.performSegue(withIdentifier: "toFeed", sender: nil)
                    
                }
                
            }
        } else {
            self.makeAnAlert(title: "Error", Description: "Please enter Email/Passwod")
        }
    }
    
    
    // MARK: Alert
    private func makeAnAlert(title: String, Description: String) {
        let alert = UIAlertController.init(title: title, message: Description, preferredStyle: .alert)
        let okButton = UIAlertAction.init(title: "ok", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

