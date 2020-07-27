//
//  SettingViewController.swift
//  InstaClone
//
//  Created by Ruby Mahto on 30/05/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func signoutTapped(_ sender: Any) {
        do {
            try! Auth.auth().signOut()
        }
        
        self.performSegue(withIdentifier: "Login", sender: nil)
    }
    
    // MARK: Action
    
    @IBAction func editProfile(_ sender: Any) {
        guard let view = EditProfileViewController.instaintateViewControllerFromStoryboard() else { return }
        
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    
    @IBAction func signoutPressed(_ sender: Any) {
        do {
            try! Auth.auth().signOut()
        }
        
        self.performSegue(withIdentifier: "Login", sender: nil)
    }
}
