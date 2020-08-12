//
//  ListingTableViewCell.swift
//  CarList
//
//  Created by Jake on 2020-08-11.
//  Copyright © 2020 Jake. All rights reserved.
//

import UIKit

class ListingTableViewCell: UITableViewCell
{
    static let reuseID = "listing_cell"
    
    @IBOutlet weak var listingImg: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var callDealerButton: UIButton!
    
    //internal
    var listing: Listing?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        callDealerButton.addTarget(self, action: #selector(callDealership), for: .touchUpInside)
    }
    
    func setupWithListing(_ listing: Listing)
    {
        self.listing = listing
        
        topLabel.text = String.init(format: "%d %@ %@", listing.year, listing.make, listing.model)
        bottomLabel.text = String.init(format: "%@ | %f | %@, %@", listing.price as CVarArg, listing.mileage, listing.city, listing.state)
        
        
        callDealerButton.setTitle(listing.telephone, for: .normal)
    }
    
    @objc fileprivate func callDealership()
    {
        //TODO add a capability check before trying to call, if device isn't capable of
        //making calls, show an alert
        if let listing = listing, let telephoneURL = URL(string: "tel://\(listing.telephone)")
        {
            UIApplication.shared.open(telephoneURL, options: [:], completionHandler: nil)
        }
    }
}
