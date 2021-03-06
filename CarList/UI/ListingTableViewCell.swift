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
    
    @IBOutlet weak var listingImgSpinner: UIActivityIndicatorView!
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
        
        callDealerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        callDealerButton.titleLabel?.baselineAdjustment = .alignCenters
        callDealerButton.layer.borderWidth = 1.0
        callDealerButton.layer.cornerRadius = 15.0
        callDealerButton.layer.borderColor = callDealerButton.tintColor.cgColor
    }
    
    func setupWithListing(_ listing: Listing)
    {
        self.listing = listing
        
        listingImgSpinner.startAnimating()
        listingImg.image = listing.fetchListingImage(completion: { (img) in
            //weak self here because we don't want this completion handler holding onto
            //a reference to the cell... if the cell goes away, we don't care about
            //completion
            DispatchQueue.main.async() { [weak self] in
                self?.listingImgSpinner.stopAnimating()
                if let img = img
                {
                    self?.listingImg.image = img
                }
            }
        })
        
        topLabel.text = String.init(format: "%d %@ %@", listing.year, listing.make, listing.model)
        bottomLabel.text = String.init(format: "%@ | %@ | %@", listing.price.priceString(withCents: false), listing.mileage.roundedDistanceString(), listing.getLocation())
        
        callDealerButton.setTitle(listing.telephone.formatAsPhoneNumber(), for: .normal)
        
        //also update the layout when we set a listing; this can happen as a result
        //of user accessibilty changes (ie: font size)
        updateLayout()
    }
    
    fileprivate func updateLayout()
    {
        topLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        bottomLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        callDealerButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        callDealerButton.layer.cornerRadius = callDealerButton.bounds.size.height / 2.0
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
                
                let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
                window?.rootViewController?.present(controller, animated: true, completion: nil)
            }
        }
    }
}
