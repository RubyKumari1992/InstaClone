//
//  ProfileViewModal.swift
//  InstaClone
//
//  Created by Ruby Mahto on 15/07/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import Foundation

protocol ProfileViewProtocol {
    func didUpdateUserProfile()
}

class ProfileViewModal {
 
    var delegate: ProfileViewProtocol?
    
    
}
