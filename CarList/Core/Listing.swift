//
//  Listing.swift
//  CarList
//
//  Created by Jake on 2020-08-11.
//  Copyright © 2020 Jake. All rights reserved.
//

import Foundation
import UIKit

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
    
    //a URL for each listing object to use when reading/writing their listing image
    fileprivate var imageCacheURL: URL?
    {
        get
        {
            if let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first
            {
                let listingDir = cacheDir.appendingPathComponent(id)
                do
                {
                    //create a directory in the cache directory for this listing by its ID
                    try FileManager.default.createDirectory(at: listingDir,
                                                            withIntermediateDirectories: true,
                                                            attributes: nil)
                    
                    //and then add the filename for the image we're caching
                    return listingDir.appendingPathComponent("mainImg")
                }
                catch
                {
                    print("Failed to create cache directory for listing")
                }
            }
            
            //if anything went wrong, don't return a URL
            return nil
        }
    }
    
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
    
    func getLocation() -> String
    {
        return city + ", " + state
    }
    
    /**
     Fetches the listing's image from the server and saves it in cache.
     Parameter completion: The block to execute after the image has successfully been fetched.
     Returns: The listing's image that we currently have in cache, if any.
     */
    func fetchListingImage(completion: @escaping (UIImage?) -> ()) -> UIImage?
    {
        URLSession.shared.dataTask(with: imageURL) { (imageData, response, error) in
            //if we received an error, or no data, or data that doesn't parse into an image,
            //fire the completion handler then bail out early
            guard error == nil,
                  let imageData = imageData,
                  let image = UIImage.init(data: imageData)
            else
            {
                completion(nil)
                return
            }
            
            //if we were able to get an image, cache it and fire it off in the
            //completion handler
            self.cacheImage(data: imageData)
            completion(image)
        }.resume()
        
        //attempt to return an image from cache while trying to fetch an update
        return loadImageFromCache()
    }
    
    fileprivate func cacheImage(data: Data)
    {
        if let imageCacheURL = imageCacheURL
        {
            do
            {
                try data.write(to: imageCacheURL)
            }
            catch
            {
                print("failed to write image to cache")
            }
        }
    }
    
    fileprivate func loadImageFromCache() -> UIImage?
    {
        var cachedImg: UIImage?
        if let imageCacheURL = imageCacheURL
        {
            do
            {
                let cacheData = try Data.init(contentsOf: imageCacheURL)
                cachedImg = UIImage.init(data: cacheData)
            }
            catch {}
        }
        
        return cachedImg
    }
}
