//
//  FireBaseHelper.swift
//  InstaClone
//
//  Created by Ruby Mahto on 11/07/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import Foundation
import Firebase

class FirebaseHelper {
    
    // MARK:- Properties
    static let shared = FirebaseHelper()
    let storage = Storage.storage()
    
    // MARK:- Constants
    
    let collection = "Posts"
    
    // MARK:- Enum
    
    
    
    private init() {}
    
    // MARK: - Functions

    func getDataFromFirestore( completion: @escaping (QuerySnapshot?,Bool) -> ()) {
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts").addSnapshotListener { (snapshot, error) in
                if error != nil {
                    print(error?.localizedDescription)
                } else {
                    if snapshot?.isEmpty != true  && snapshot != nil{
                        DispatchQueue.main.async {
                            completion(snapshot,true)
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            completion(nil,false) }
                    }
                }
            
        }
    }
    
    func getImage(url: String, completion: @escaping (Data?, Bool) -> ()) {
        guard let urlsString = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: urlsString) { (data, response, error) in
            if data != nil && error == nil {
                DispatchQueue.main.async {
                    completion(data,true)
                }
                completion(nil,false)
            }
        }
        task.resume()
        
    }
}

// MARK: Extension for Firebase Strorage
extension FirebaseHelper {
    
//    func savePost(imageType: ImageType,image: UIImage?, comment: String, completion: @escaping (Error?) -> ()) {
//        
//        let storageRef = self.storage.reference()
//        let mediaFolder = storageRef.child(ImageType.posts.rawValue)
//        DispatchQueue.global(qos: .background).async {
//            guard let data = image?.jpegData(compressionQuality: 0.5) else { return }
//            let uuid = UUID().uuidString
//            let imageReference = mediaFolder.child("\(uuid).jpg")
//            imageReference.putData(data, metadata: nil) { (metaData, error) in
//                if error != nil {
//                    print(error?.localizedDescription ?? "Error Occured")
//                    DispatchQueue.main.async {
//                        completion(error)
//                    }
//                    
//                } else {
//                    imageReference.downloadURL { (url, error) in
//                        print("url after uploading\(String(describing: url?.absoluteString))")
//                        if error == nil {
//                            let imageUrl = url?.absoluteString
//                            let data = StorageData(url: imageUrl!, comment: comment, likes: 0, postedBy: Auth.auth().currentUser!.email!, date: "Date")
//                            
//                            data.storeData { (error) in
//                                
//                            }
//                        }
//                        DispatchQueue.main.async {
//                            completion(error)
//                        }
//                        
//                    }
//                    
//                }
//                
//            }
//            
//        }
//    }
//    
    
    func updateProfileForPost(url: URL?, completion: @escaping (Bool) -> ()) {
        var dataArray = [Posts]()
        let firestoredatabase = Firestore.firestore()
        let data = ["profileImage": url?.absoluteString as Any] as [String: Any]
        DispatchQueue.global(qos: .background).async {
        
        self.getDataFromFirestore { (snapshot, result) in
            if result {
                guard let snapshot = snapshot else { return }
                dataArray = try! snapshot.decode()
            }
            for values in dataArray {
                if values.postedBy == Auth.auth().currentUser?.email  && values.profileImage != url?.absoluteString  || values.profileImage == nil {
                    firestoredatabase.collection(self.collection).document(values.documentID!).setData(data, merge: true)
                }
            }
            completion(true)
        }
        
        }
    }
}
