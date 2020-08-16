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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
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
        
        //add a pull-to-refresh controller to the table
        let refresher = UIRefreshControl.init()
        refresher.attributedTitle = NSAttributedString.init(string: NSLocalizedString("listings.fetching",
                                                                                      comment: ""))
        refresher.addTarget(self,
                            action: #selector(updateListingsFromServer),
                            for: .valueChanged)
        tableView.refreshControl = refresher
        
        //do the initial setup with a loading screen and fetch
        performInitialFetch()
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
    
    @objc func updateListingsFromServer()
    {
        manager.updateListingsWith {
            //allow for one whole second of loading to reduce jitteryness
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            })
        }
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
    
    // MARK: Helper methods
    
    fileprivate func performInitialFetch()
    {
        //hide the table and show the loading indicator before starting a fetch
        spinner.startAnimating()
        loadingLabel.isHidden = false
        tableView.alpha = 0.0
        
        manager.updateListingsWith {
            //once fetch is complete, hide loading elements and reload/show the table
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.spinner.stopAnimating()
                self.loadingLabel.isHidden = true
                UIView.animate(withDuration: 0.25) {
                    self.tableView.alpha = 1.0
                }
            }
        }
    }
}

