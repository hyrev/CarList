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
        bottomLabel.text = String.init(format: "%@ | %f | %@, %@", listing.price.priceString(withCents: false) as CVarArg, listing.mileage, listing.city, listing.state)
        
        
        callDealerButton.setTitle(listing.telephone, for: .normal)
    }
    
    @objc fileprivate func callDealership()
    {
        if let listing = listing, let telephoneURL = URL(string: "tel://\(listing.telephone)")
        {
            if UIApplication.shared.canOpenURL(telephoneURL)
            {
                //if this device is capable of making telephone calls do it!
                UIApplication.shared.open(telephoneURL, options: [:], completionHandler: nil)
            }
            else
            {
                //otherwise, tell the user that this device can't do it
                let title = NSLocalizedString("error.phone-not-available.title", comment: "")
                let body = NSLocalizedString("error.phone-not-available.body", comment: "")
                let controller = UIAlertController.init(title: title, message: body, preferredStyle: .alert)
                controller.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                
                //TODO present this alert in a better way
                UIApplication.shared.keyWindow?.rootViewController?.present(controller, animated: true, completion: nil)
            }
        }
    }
}
