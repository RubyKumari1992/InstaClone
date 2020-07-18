//
//  customCell.swift
//  InstaClone
//
//  Created by Ruby Mahto on 02/06/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import UIKit
import Firebase

protocol feedCellProtocol {
    func receivedCount()
}

class FeedCell: UITableViewCell{
    
    // MARK:-  Outlets
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var comments: UILabel!
    
    @IBOutlet weak var likesCount: UILabel!
    
    @IBOutlet weak var images: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    var documentID = String()
    var document = String()
    var delegate: feedCellProtocol?
    // MARK:- Action
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.images.image = nil
}
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        
        let FireStoreDatabase = Firestore.firestore()
        if let likeCount = Int(self.likesCount.text!) {
            let likeStore = ["likes": likeCount + 1] as [String: Any]
            DispatchQueue.global(qos: .background).async {
                FireStoreDatabase.collection("Posts").document(self.documentID).setData(likeStore, merge: true)
            }
        }
        
    }
    
    func confiureCell(posts: Posts, tag: Int, index: Int) {
        self.userName.text = posts.postedBy
        self.comments.text = posts.comment
        self.profileImage.setProfileImageByURL(urlString: posts.profileImage)
        self.images.setImageByURL(urlString: posts.imageURL, placeholderImage: "placeholderImage")
      
        if let docID = posts.documentID {
            self.documentID = docID
        }
        if let likeCount = posts.likes {
            self.likesCount.text = "\(likeCount)"
        }
    }
}
