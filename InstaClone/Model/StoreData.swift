//
//  StoreData.swift
//  InstaClone
//
//  Created by Ruby Mahto on 31/05/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import Foundation
import Firebase

struct StorageData {
    var url: String?
    var comment: String?
    var likes: Int?
    var postedBy: String?
    var date: String?
    
    init(url: String, comment: String, likes: Int, postedBy: String, date: String) {
        self.url = url
        self.comment = comment
        self.likes = likes
        self.postedBy = postedBy
        self.date = date
    }
    
    func storeData(completion: @escaping (Error?) -> ()) {
        let firestoreDatabase = Firestore.firestore()
        var firestoreReference: DocumentReference? = nil
        let firestorePost = ["imageurl": self.url, "postedBy": self.postedBy, "comment": self.comment, "likes": self.likes, "Date": self.date, "profileImage": Auth.auth().currentUser?.photoURL?.absoluteString] as [String: Any]
        DispatchQueue.global(qos: .background).async {
            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                if error != nil {
                    print("there is some error")
                }
                guard let documentID = firestoreReference?.documentID else { return }
                firestoreReference?.setData(["DocumentID": documentID], merge: true, completion: { (error) in
                    if error != nil {
                        print("there is some error")
                    }
                    completion(error)
                })
            })
            
        }
    }
}
