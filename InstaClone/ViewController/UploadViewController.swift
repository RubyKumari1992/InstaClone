//
//  UploadViewController.swift
//  InstaClone
//
//  Created by Ruby Mahto on 30/05/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.enableUserInteraction()
        
    }
    
    private func enableUserInteraction() {
        self.imageView.isUserInteractionEnabled = true
        let gestureReconizer = UITapGestureRecognizer(target: self, action: #selector(ChooseImage))
        self.imageView.addGestureRecognizer(gestureReconizer)
    }
    
    @objc func ChooseImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true, completion:  nil)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        FirebaseHelper.shared.savePost(imageType: .posts, image: self.imageView.image, comment: self.commentField.text!) { (error) in
            if error != nil {
                print("error while uploading image")
            } else {
                self.tabBarController?.selectedIndex = 0
            }
        }
        
        
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}
