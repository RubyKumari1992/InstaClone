//
//  EditProfileViewController.swift
//  InstaClone
//
//  Created by Ruby Mahto on 12/07/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var nameTextFiled: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableUserInteraction()
        self.updateView()
    }
    
    class func instaintateViewControllerFromStoryboard() -> EditProfileViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editProfileView = storyboard.instantiateViewController(identifier: "EditProfileViewController") as? EditProfileViewController
        return editProfileView
    }
    
    private func updateView() {
        self.profileImage.setProfileImageByURL(urlString: Auth.auth().currentUser?.photoURL?.absoluteString)
        guard let email = Auth.auth().currentUser?.email, let name = Auth.auth().currentUser?.displayName else { return }
        self.emailTextField.text! = email
        self.nameTextFiled.text! = name
    }
    
    private func enableUserInteraction() {
        self.profileImage.isUserInteractionEnabled = true
        let gestureReconizer = UITapGestureRecognizer(target: self, action: #selector(ChooseImage))
        self.profileImage.addGestureRecognizer(gestureReconizer)
    }
    
    @objc func ChooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion:  nil)
    }
    
    // MARK: Actions
    
    @IBAction func saveProfileButton(_ sender: Any) {
        print(Auth.auth().currentUser?.photoURL)
        if self.nameTextFiled.text != "" {
            guard let image = profileImage.image else { return }
            let profile = ProfileDetails()
            profile.updateProfile(image: image, name: self.nameTextFiled.text!, previousImageURL: Auth.auth().currentUser?.photoURL?.absoluteString) { (error, url) in
                if error != nil {
                    print("there is some error while uploading image")
                    return
                }
                FirebaseHelper.shared.updateProfileForPost(url: Auth.auth().currentUser?.photoURL) { (result) in
                    if result == true {
                        self.tabBarController?.selectedIndex = 0
                    }
                }
                print("after updating profile url")
                print(Auth.auth().currentUser?.photoURL)
                
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
    }
    
    
}

// MARK: Extension

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageTobeShowed = info[.originalImage] as? UIImage
        self.profileImage.image = imageTobeShowed?.scaleToSize(aSize: CGSize(width: 100, height: 100))
        self.dismiss(animated: true, completion: nil)
    }
}
