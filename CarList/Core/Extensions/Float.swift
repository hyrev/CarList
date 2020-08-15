//
//  Float.swift
//  CarList
//
//  Created by Jake on 2020-08-12.
//  Copyright © 2020 Jake. All rights reserved.
//

import Foundation

extension Float
{
    /**
     - returns: a nice, human readable, rounded string for this exact mileage. If the mileage is less than 10k, round to the nearest mile, otherwise round to the nearest thousand miles
     */
    func roundedDistanceString() -> String
    {
        if self < 10000
        {
            return String.init(format: "%d Mi", Int(self))
        }
        
        return String.init(format: "%dk Mi", Int(self / 1000))
    }
}
