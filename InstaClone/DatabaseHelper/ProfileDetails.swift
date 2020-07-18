//
//  ProfileDetails.swift
//  InstaClone
//
//  Created by Ruby Mahto on 14/07/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//


import Foundation
import Firebase
import UIKit

class ProfileDetails {
    
    // MARK: Variable
    var previousURL: String?
    let storage = Storage.storage()
    
    // MARK:- Functions
    
    /* @param image: Image which is to be updates
        @param previousImageURL: Previous url for profile image 
     
     */
    
    func updateProfile(image: UIImage, name: String, previousImageURL: String?, completion: @escaping (Error?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            guard let data = image.jpegData(compressionQuality: 0.5)  else { return }
            if previousImageURL != nil {
                self.previousURL = previousImageURL
                self.deleteProfileImage { (error) in
                    if error != nil {
                        print("error while deleting")
                    }
                    
                }
                
            }
            self.updateProfileImage(data: data) { (error, url) in
                print("URL after updating image\(String(describing: url))")
                if url != nil {
                    FirebaseHelper.shared.updateProfileForPost(url: url) { (result) in
                        print(result)
                    }
                }
                completion(error)
            }
        }
    }
    
    private func deleteProfileImage(completion: @escaping (Error?) -> ()) {
        let reference = self.storage.reference(forURL: self.previousURL!)
        reference.delete { (error) in
            if error != nil {
                print("error while deleting old image")
            }
        }
    }
    private func updateProfileImage(data: Data, completion: @escaping (Error?, URL?) -> ()) {
        
        let uuid = UUID().uuidString
        var imageReference = storage.reference()
        let folderPath = imageReference.child("ProfileImageURL")
        imageReference = folderPath.child("\(uuid).jpg")
        imageReference.putData(data, metadata: nil) { (metaData, error) in
            if error != nil {
                print("there is some error while uploading")
            } else {
                imageReference.downloadURL { (url, error) in
                    if error != nil {
                        print("error while downloading")
                    } else {
                        
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.photoURL = url
                        //changeRequest?.displayName = name
                        changeRequest?.commitChanges(completion: { (error) in
                            if error != nil {
                                print("there is an error")
                            }
                            DispatchQueue.main.async {
                                completion(error, Auth.auth().currentUser?.photoURL)
                            }
                            
                        })
                    }
                }
            }
        }
    }
}
