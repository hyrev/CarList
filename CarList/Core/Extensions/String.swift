//
//  String.swift
//  CarList
//
//  Created by Jake on 2020-08-12.
//  Copyright © 2020 Jake. All rights reserved.
//

import Foundation

extension String
{
    /**
     - returns: This string formatted as (###) ###-#### if its exactly 10 characters long, otherwise just return itself
     */
    func formatAsPhoneNumber() -> String
    {
        //if this string isn't 10 characters long, bail early because it's not
        //the length we expect
        if self.count != 10
        {
            return self;
        }
        
        //if this string contains non-digit characters, bail early because it's not
        //the format we expect
        if Int64(self) == nil
        {
            return self
        }
        
        //set up indices for the "chunks" of the phone number
        let firstIndex = self.index(self.startIndex, offsetBy: 3)
        let secondIndex = self.index(firstIndex, offsetBy: 3)
        return String.init(format: "(%@) %@-%@", String(self[startIndex..<firstIndex]),
                                                 String(self[firstIndex..<secondIndex]),
                                                 String(self[secondIndex..<endIndex]))
    }
}
