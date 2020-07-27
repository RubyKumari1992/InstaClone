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
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    // MARK: Variables
    
    var uploadViewModal: UploadViewModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadViewModal = UploadViewModal(delegate: self)
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
        
        self.uploadViewModal?.savePost(imageType: .posts, image: self.imageView.image, comment: self.commentField.text!)
    }
    
    
    private func makeAnAlert(title: String, Description: String) {
        let alert = UIAlertController.init(title: title, message: Description, preferredStyle: .alert)
        let okButton = UIAlertAction.init(title: "ok", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK:- Extension
extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
}

extension UploadViewController: UploadViewModalProtocol {
    func didFinishUploading(result: Result<Bool, Error>) {
        switch result {
        case .success( _):
            self.tabBarController?.selectedIndex = 0
        case .failure:
            self.makeAnAlert(title: "Error", Description: "There was an Error while uploading")
            
        }
        
    }
}
