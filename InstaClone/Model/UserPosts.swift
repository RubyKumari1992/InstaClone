//
//  UserPosts.swift
//  InstaClone
//
//  Created by Ruby Mahto on 06/07/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import Foundation


struct Posts: Decodable {
    var date: String?
    var comment: String?
    var likes: Int?
    var postedBy: String?
    var imageURL: String?
    var documentID: String?
    var profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "imageurl"
        case date = "Date"
        case likes = "likes"
        case comment = "comment"
        case postedBy = "postedBy"
        case documentID = "DocumentID"
        case profileImage = "profileImage"
    }
}
