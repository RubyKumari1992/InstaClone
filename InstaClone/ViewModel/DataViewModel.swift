//
//  DataViewModel.swift
//  InstaClone
//
//  Created by Ruby Mahto on 06/07/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import Foundation
import Firebase

protocol DataViewModelProtocol {
    func receiveData(posts: [Posts])
}
class DataViewModel: NSObject {
    
 
    var delegate: DataViewModelProtocol?
     var postsArray = [Posts]()
    
    // MARK: Initializer
    
    init(delegate: DataViewModelProtocol) {
        self.delegate = delegate
    }
    
    func getData() {
           var postsArray = [Posts]()
        FirebaseHelper.shared.getDataFromFirestore { (snapshot, result) in
            if result {
                guard let snapshot = snapshot else { return }
                self.postsArray = try! snapshot.decode()
                print(self.postsArray)
                self.delegate?.receiveData(posts: self.postsArray)
            }
        }
    }
}
