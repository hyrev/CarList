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
    static let kListingsEndpoint = "https://carfax-for-consumers.firebaseio.com/assignment.json"
    static let kListingsKey = "listings"
    
    //a URL that points to a local copy of the json listings in cache
    fileprivate var listingsCacheURL: URL?
    {
        get
        {
            if let cacheDir = FileManager.default.urls(for: .cachesDirectory,
                                                       in: .allDomainsMask).first
            {
                return cacheDir.appendingPathComponent("listings.json")
            }

            //if anything went wrong, don't return a URL
            return nil
        }
    }
    
    var listings: [Listing] = []
    
    func updateListingsWith(completion: @escaping () -> ())
    {
        if let listingsURL = URL.init(string: ListingManager.kListingsEndpoint)
        {
            URLSession.shared.dataTask(with: listingsURL) { (jsonData, response, error) in
                if let listingsCacheURL = self.listingsCacheURL
                {
                    if let jsonData = jsonData
                    {
                        do
                        {
                            try jsonData.write(to: listingsCacheURL)
                        }
                        catch
                        {
                            print("failed to write json to cache")
                        }
                    }

                    self.listings = self.parseJSONListings(from: listingsCacheURL)
                    completion()
                }
            }.resume()
        }
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
