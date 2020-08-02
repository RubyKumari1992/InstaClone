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
