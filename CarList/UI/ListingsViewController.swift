//
//  ViewController.swift
//  CarList
//
//  Created by Jake on 2020-08-10.
//  Copyright © 2020 Jake. All rights reserved.
//

import UIKit

class ListingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    //internal
    fileprivate let manager = ListingManager.init()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        //trick for removing unwanted divider lines at the bottom of the table
        tableView.tableFooterView = UIView.init(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateAccessibility(notification:)),
                                               name: UIContentSizeCategory.didChangeNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIContentSizeCategory.didChangeNotification,
                                                  object: nil)
    }
    
    // MARK: Notification methods
    
    @objc func updateAccessibility(notification: Notification)
    {
        //cells update their layout when they are loaded, so all we need to do here is reload the table
        tableView.reloadData()
    }

    // MARK: UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return manager.listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListingTableViewCell.reuseID) as! ListingTableViewCell
        cell.setupWithListing(manager.listings[indexPath.row])
        
        return cell
    }
}

