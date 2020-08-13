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
    func getRoundedDistanceStr() -> String
    {
        if self < 10000
        {
            return String.init(format: "%d Mi", Int(self))
        }
        
        return String.init(format: "%dk Mi", Int(self / 1000))
    }
}
