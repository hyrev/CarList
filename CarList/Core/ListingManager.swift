//
//  ListingManager.swift
//  CarList
//
//  Created by Jake on 2020-08-11.
//  Copyright © 2020 Jake. All rights reserved.
//

import Foundation

class ListingManager
{
    static let kListingsKey = "listings"
    var listings: [Listing] = []
    
    init()
    {
        //TODO: fetch this content from the server, and also don't explicitly unwrap optionals
        //ok for now, because we're testing with local data thats guaranteed to exist
        let embeddedURL = Bundle.main.url(forResource: "listings", withExtension: "json")
        self.listings = parseJSONListings(from: embeddedURL!)
    }
    
    fileprivate func parseJSONListings(from jsonURL: URL) -> [Listing]
    {
        var tempListings: [Listing] = []
        
        do
        {
            let embeddedData = try Data(contentsOf: jsonURL)
            let json = try JSONSerialization.jsonObject(with: embeddedData,
                                                        options: .allowFragments) as! Dictionary<String, Any>
            
            if let jsonList = json[ListingManager.kListingsKey] as? [Dictionary<String, Any>]
            {
                for jsonObj in jsonList
                {
                    if let listing = Listing.init(json: jsonObj)
                    {
                        tempListings.append(listing)
                    }
                }
            }
        }
        catch
        {
            print("Failed to parse listings from json: \(error)")
        }
        
        return tempListings
    }
}
