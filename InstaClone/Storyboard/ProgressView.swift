//
//  ProgressView.swift
//  InstaClone
//
//  Created by Ruby Mahto on 27/07/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import UIKit
import Foundation

class ProgressView: NSObject {
    
    static let sharedInstance = ProgressView()
    private let activityIndicator = UIActivityIndicatorView()
    
    //MARK: - Private Methods -
    private func setupLoader() {
        removeLoader()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
    }
    
    //MARK: - Public Methods -
    func showLoader(view: UIView) {
        setupLoader()
        
        DispatchQueue.main.async {
            self.activityIndicator.center = view.center
            self.activityIndicator.startAnimating()
            view.addSubview(self.activityIndicator)
        }
    }
    
    func removeLoader(){
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
