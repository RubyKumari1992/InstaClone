//
//  UIImage+Extension.swift
//  InstaClone
//
//  Created by Ruby Mahto on 11/07/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import Foundation
import UIKit


let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImage {
    func scaleToSize(aSize: CGSize) -> UIImage? {
        if (__CGSizeEqualToSize(self.size, aSize)) {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(aSize, false, 0.0)
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: aSize.width, height: aSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImageView {
    
    func setImageByURL(urlString: String?, placeholderImage: String?) {
        guard let url = urlString else { return }
        if placeholderImage != nil {
            self.image = UIImage(named: "placeholderImage")?.scaleToSize(aSize: CGSize(width: 355, height: 300))
        }
        if let imageForCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageForCache
            print("image", imageForCache)
            return
        } else {
            
            FirebaseHelper.shared.getImage(url: url) { (data, result) in
                if result {
                    guard let data = data else { return }
                    guard let newImage = UIImage(data: data)?.scaleToSize(aSize: CGSize(width: 355, height: 300)) else { return }
                    imageCache.setObject(newImage, forKey: (url as AnyObject) as! NSString)
                    self.image = newImage
                    
                }
            }
            
        }
    }
    
    func setProfileImageByURL(urlString: String?) {
        self.layer.cornerRadius = self.frame.size.width /
        2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
        self.image = UIImage(named: "userImage")
        guard let url = urlString else { return }
        FirebaseHelper.shared.getImage(url: url) { (data, error) in
            guard let data = data else { return }
            guard let newImage = UIImage(data: data) else { return }
            self.image = newImage
            
        }
        
    }
}

