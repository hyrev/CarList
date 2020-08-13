//
//  Decimal.swift
//  CarList
//
//  Created by Jake on 2020-08-11.
//  Copyright © 2020 Jake. All rights reserved.
//

import Foundation

extension Decimal
{
    /**
     - parameter withCents: true if you want the price string to show a decimal and two decimal places for cents, false if you want to omit the decimal entirely
     - returns: a string representation of this decimal, formatted as a localized price
     */
    func priceString(withCents: Bool) -> String
    {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = (withCents ? 2 : 0)
        
        return formatter.string(from: self as NSNumber) ?? "unknown"
    }
}
