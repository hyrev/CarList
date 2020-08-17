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
    
    /**
     Fetches the latest listings from the server, saves them to cache, then loads listings from there.
     Ideally this method would implement HTTP 304 somehow so we'd only download new data if the data differed from what we have.
     Will filre the completion block regardless of whether or not this request is successful.
     - Parameter completion: A block to fire after this request completes, not guaranteed to run on the main thread
     */
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
    
    /**
     Reads a json file from a URL and parses the contents of the file at that URL into an array of Listing objects.
     - Parameter jsonURL: URL of a json file, currently only being used for files in cache.
     - Returns: an array of Listing objects successfully instantiated from the json.
     */
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
