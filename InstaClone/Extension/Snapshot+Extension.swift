//
//  Snapshot+Extension.swift
//  InstaClone
//
//  Created by Ruby Mahto on 08/07/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import Foundation
import Firebase

extension QueryDocumentSnapshot {
    func decode<T: Decodable>() throws -> T {
    
        let jsonData = try JSONSerialization.data(withJSONObject: data(), options: [])
        print("printing data" ,data())
        let object = try JSONDecoder().decode(T.self, from: jsonData)
        return object
    }
}

extension QuerySnapshot {
    func decode<T: Decodable>() throws -> [T] {
        let objects: [T] = try documents.map({ try $0.decode() })
        return objects
    }
}
