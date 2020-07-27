//
//  HomeViewController.swift
//  InstaClone
//
//  Created by Ruby Mahto on 30/05/20.
//  Copyright © 2020 Ruby Mahto. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class HomeViewController: UIViewController {
    
    var dataArray = [Posts]()
    var dataViewModel: DataViewModel?
    @IBOutlet weak var feedTableView: UITableView! {
        didSet {
            feedTableView.dataSource = self
            feedTableView.delegate = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        dataViewModel = DataViewModel(delegate: self)
        feedTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataViewModel?.getData()
        
    }
}

// MARK:- Extension

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToFeedCell", for: indexPath) as! FeedCell
        cell.confiureCell(posts: dataArray[indexPath.row], tag: cell.tag, index: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
}

extension HomeViewController: DataViewModelProtocol {
    
    func receiveData(posts: [Posts]) {
        self.dataArray = posts
        self.feedTableView.reloadData()
    }
}
