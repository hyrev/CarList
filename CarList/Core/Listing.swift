//
//  Listing.swift
//  CarList
//
//  Created by Jake on 2020-08-11.
//  Copyright © 2020 Jake. All rights reserved.
//

import Foundation

class Listing
{
    let make: String
    let model: String
    let trim: String
    let year: Int
    let price: Decimal
    let mileage: Float
    let city: String
    let state: String
    let telephone: String
    
    fileprivate let id: String
    fileprivate let imageURL: URL
    
    init?(json: Dictionary<String, Any>)
    {
        //ensure the listing object has all of the elements that we require
        //if it does not, bail out early
        guard let make = json[ListingKeys.make] as? String,
              let model = json[ListingKeys.model] as? String,
              let trim = json[ListingKeys.trim] as? String,
              let year = json[ListingKeys.year] as? Int,
              let price = json[ListingKeys.price] as? Double,
              let mileage = json[ListingKeys.mileage] as? Float,
              let dealer = json[ListingKeys.dealer] as? Dictionary<String, Any>,
              let city = dealer[DealerKeys.city] as? String,
              let state = dealer[DealerKeys.state] as? String,
              let telephone = dealer[DealerKeys.phoneNumber] as? String,
              let id = json[ListingKeys.id] as? String,
              let imageDict = json[ListingKeys.images] as? Dictionary<String, Any>,
              let firstPhotoDict = imageDict[ImageKeys.firstPhoto] as? Dictionary<String, Any>,
              let firstPhotoStr = firstPhotoDict[ImageKeys.large] as? String,
              let imageURL = URL.init(string: firstPhotoStr)
        else
        {
            return nil
        }
        
        self.make = make
        self.model = model
        self.trim = trim
        self.year = year
        self.price = Decimal.init(price)
        self.mileage = mileage
        self.city = city
        self.state = state
        self.telephone = telephone
        
        self.id = id
        self.imageURL = imageURL
    }
}
