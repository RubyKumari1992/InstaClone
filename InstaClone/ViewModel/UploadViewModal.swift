//
//  UploadViewModal.swift
//  InstaClone
//
//  Created by Ruby Mahto on 20/07/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import Foundation
import Firebase
import UIKit

protocol UploadViewModalProtocol {
    func didFinishUploading(result: Result<Bool, Error>)
}

enum UploadError: Error {
    case uploadFails
}

class UploadViewModal: NSObject {
    
    // MARK:- Variable
    
    var delegate: UploadViewModalProtocol?
    let storage = Storage.storage()
    var previousURL: String?
    
    // MARK: Initializer
    
    init(delegate: UploadViewModalProtocol) {
        self.delegate = delegate
    }
    
    // MARK:- Function
    
    func savePost(imageType: ImageType,image: UIImage?, comment: String) {
        
        let storageRef = self.storage.reference()
        let mediaFolder = storageRef.child(ImageType.posts.rawValue)
        DispatchQueue.global(qos: .background).async {
            guard let data = image?.jpegData(compressionQuality: 0.5) else { return }
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            self.saveImageToFirebase(data: data, imageReference: imageReference) { (result, error) in
                if result == true && error == nil {
                    self.downloadURL(imageReference: imageReference) { (url) in
                        if url != nil {
                            guard let imageUrl = url?.absoluteString else { return }
                            let data = StorageData(url: imageUrl, comment: comment, likes: 0, postedBy: Auth.auth().currentUser!.email!, date: "Date")
                            
                            data.storeData { (error) in
                                if error == nil {
                                    DispatchQueue.main.async {
                                        self.delegate?.didFinishUploading(result: .success(true))
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.delegate?.didFinishUploading(result: .failure(UploadError.uploadFails))
                    }
                }
                
            }
        }
    }
    
    // Update user profile
    func updateProfile(image: UIImage, name: String, previousImageURL: String?) {
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
                if url != nil  && error == nil {
                    self.updateProfileForPost(url: url) { (result) in
                        if result {
                            DispatchQueue.main.async {
                                self.delegate?.didFinishUploading(result: .success(true))
                            }
                            
                        } else {
                            DispatchQueue.main.async {
                                self.delegate?.didFinishUploading(result: .failure(UploadError.uploadFails))
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    // Delete the previous profile of the user
    private func deleteProfileImage(completion: @escaping (Error?) -> ()) {
        let reference = self.storage.reference(forURL: self.previousURL!)
        reference.delete { (error) in
            if error != nil {
                print("error while deleting old image")
            }
        }
    }
    
    // Update the update the profile image of the user
    private func updateProfileImage(data: Data, completion: @escaping (Error?, URL?) -> ()) {
        
        let uuid = UUID().uuidString
        var imageReference = storage.reference()
        let folderPath = imageReference.child("ProfileImageURL")
        imageReference = folderPath.child("\(uuid).jpg")
        self.saveImageToFirebase(data: data, imageReference: imageReference) { (result, error) in
            if result == true && error == nil {
                self.downloadURL(imageReference: imageReference) { (url) in
                    if url != nil {
                        guard let imageURL = url else { return }
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.photoURL = imageURL
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
    
    
    // Update the image url of the user
    
    func updateProfileForPost(url: URL?, completion: @escaping (Bool) -> ()) {
        var dataArray = [Posts]()
        let firestoredatabase = Firestore.firestore()
        let data = ["profileImage": url?.absoluteString as Any] as [String: Any]
        DispatchQueue.global(qos: .background).async {
            
            FirebaseHelper.shared.getDataFromFirestore { (snapshot, result) in
                if result {
                    guard let snapshot = snapshot else { return }
                    dataArray = try! snapshot.decode()
                }
                for values in dataArray {
                    if values.postedBy == Auth.auth().currentUser?.email  && values.profileImage != url?.absoluteString  || values.profileImage == nil {
                        firestoredatabase.collection("Posts").document(values.documentID!).setData(data, merge: true)
                    }
                }
                
            }
            completion(true)
        }
    }
    
    // Save image to the firebase
    private func saveImageToFirebase(data: Data, imageReference: StorageReference, completion: @escaping (Bool?, Error?) ->()) {
        
        imageReference.putData(data, metadata: nil) { (metaData, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error Occured")
                completion(false , error)
                
            } else {
                completion(true, nil)
            }
            
        }
    }
    
    // Download the url of the image
    private func downloadURL(imageReference: StorageReference, completion: @escaping (URL?) -> ()) {
        imageReference.downloadURL { (url, error) in
            print("url after uploading\(String(describing: url?.absoluteString))")
            if error == nil {
                completion(url)
            }
        }
        
    }
    
    
}
