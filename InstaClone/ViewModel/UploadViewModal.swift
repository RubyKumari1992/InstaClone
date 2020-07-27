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
    
    //
    private func downloadURL(imageReference: StorageReference, completion: @escaping (URL?) -> ()) {
        imageReference.downloadURL { (url, error) in
            print("url after uploading\(String(describing: url?.absoluteString))")
            if error == nil {
                completion(url)
            }
        }
        
    }
    
    
}
