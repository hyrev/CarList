//
//  CarListTests.swift
//  CarListTests
//
//  Created by Jake on 2020-08-15.
//  Copyright © 2020 Jake. All rights reserved.
//

import XCTest

@testable import CarList

class CarListTests: XCTestCase {

    var validListing: Listing?
    
    override func setUpWithError() throws
    {
        let bundle = Bundle(for: type(of: self))
        let validListingURL = bundle.url(forResource: "ValidListing",
                                         withExtension: "json")!
        let embeddedData = try Data(contentsOf: validListingURL)
        let json = try JSONSerialization.jsonObject(with: embeddedData,
                                                    options: .allowFragments) as! Dictionary<String, Any>
        
        validListing = Listing.init(json: json)
    }

    override func tearDownWithError() throws
    {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: Listing class tests
    
    func testListingParsing() throws
    {
        XCTAssertEqual(validListing?.make, "Acura")
        XCTAssertEqual(validListing?.model, "TLX")
        XCTAssertEqual(validListing?.year, 2020)
        XCTAssertEqual(validListing?.price, 31985.0)
        XCTAssertEqual(validListing?.mileage, 1550.0)
        XCTAssertEqual(validListing?.getLocation(), "Manassas, VA")
    }

    // MARK: Decimal extension tests
    
    func testPriceFormatting() throws
    {
        let oneDollar = Decimal.init(1)
        XCTAssertEqual(oneDollar.priceString(withCents: true), "$1.00")
        XCTAssertEqual(oneDollar.priceString(withCents: false), "$1")
        
        let negativeDollars = Decimal.init(-123)
        XCTAssertEqual(negativeDollars.priceString(withCents: true), "-$123.00")
        XCTAssertEqual(negativeDollars.priceString(withCents: false), "-$123")
    }
    
    // MARK: Double extension tests
    
    func testRoundedDistanceFormatting() throws
    {
        let shortDistance = 1000.0
        XCTAssertEqual(shortDistance.roundedDistanceString(), "1000 Mi")
        
        let longDistance = 256000.0
        XCTAssertEqual(longDistance.roundedDistanceString(), "256k Mi")
        
        let shortNegativeDistance = -250.0
        XCTAssertEqual(shortNegativeDistance.roundedDistanceString(), "-250 Mi")
        
        let longNegativeDistance = -500000.0
        XCTAssertEqual(longNegativeDistance.roundedDistanceString(), "-500k Mi")
    }
    
    //MARK: String extension tests
    
    func testPhoneNumberFormatting() throws
    {
        let validPN = "5198786269"
        XCTAssertEqual(validPN.formatAsPhoneNumber(), "(519) 878-6269")
        
        let tooShort = "12345"
        XCTAssertEqual(tooShort.formatAsPhoneNumber(), tooShort)
        
        let tooLong = "519235227722"
        XCTAssertEqual(tooLong.formatAsPhoneNumber(), tooLong)
        
        let emptyString = ""
        XCTAssertEqual(emptyString.formatAsPhoneNumber(), emptyString)
        
        let invalidChars = "51922782az"
        XCTAssertEqual(invalidChars.formatAsPhoneNumber(), invalidChars)
        
        let garbage = "not even a digit in here"
        XCTAssertEqual(garbage.formatAsPhoneNumber(), garbage)
    }

}
