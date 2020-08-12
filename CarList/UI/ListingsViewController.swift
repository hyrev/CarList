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

