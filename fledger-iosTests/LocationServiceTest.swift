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

    let service = LocationService<Location>(DatabaseService.main)

    func testModelType() {
        XCTAssert(service.modelType() == ModelType.Location, "model type is location")
    }

}
