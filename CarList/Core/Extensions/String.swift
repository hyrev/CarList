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
    func formatAsPhoneNumber() -> String
    {
        //if this string isn't 10 characters long, bail early because it's not
        //the length we expect
        if self.count != 10
        {
            return self;
        }
        
        //set up indices for the "chunks" of the phone number
        let firstIndex = self.index(self.startIndex, offsetBy: 3)
        let secondIndex = self.index(firstIndex, offsetBy: 3)
        return String.init(format: "(%@) %@-%@", String(self[startIndex..<firstIndex]),
                                                 String(self[firstIndex..<secondIndex]),
                                                 String(self[secondIndex..<endIndex]))
    }
}
