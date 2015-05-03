//
//  LocationServiceTest.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/1/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import XCTest
import fledger_ios


class LocationServiceTest: XCTestCase {

    var database: DatabaseService!
    var location: LocationService<Location>!
    
    override func setUp() {
        super.setUp()
        
        database = DatabaseServiceMock()
        database.createDatabaseDestructive()
    
        location = LocationService<Location>(database)
    }

    func testModelType() {
        XCTAssert(location.modelType() == ModelType.Location, "model type is location")
    }

}
