//
//  LocationServiceTest.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/1/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import XCTest
import fledger_ios


class LocationServiceImplSuite: AppTestSuite {

    static let service_: LocationServiceImpl<Location> = {
        let db = DatabaseServiceMock()
        db.createDatabaseDestructive()
        Services.register(DatabaseService.self, db)
        return LocationServiceImpl()
    }()

    let service = LocationServiceImplSuite.service_

    func testModelType() {
        XCTAssertEqual(service.modelType(), ModelType.Location)
    }
    
    func testWithId() {
        let coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)
        let location = Location(id: nil, name: "name", coordinate: coordinate, address: "address", distance: nil)
        let id = service.insert(location)
        let result = service.withId(id!)
        XCTAssertEqual(location.withId(id), result!)
        
        let location2 = location.copy(name: "name2", address: "address2")
        let id2 = service.insert(location2)
        let result2 = service.withId(id2!)
        XCTAssertEqual(location2.withId(id2), result2!)
        
        // fail due to duplicate name/address
        let id3 = service.insert(location2)
        XCTAssert(id3 == nil)
    }
    
    func testAll() {
        
    }
    
    func testSelect() {
        
    }
    
    func testCount() {
        
    }
    
    func testInsert() {
        
    }
    
    func testUpdate() {
        
    }
    
    func testDelete() {
        
    }
    
    func testInvalidate() {
        
    }
    
    func testItemCount() {
        
    }
    
    func testNearest() {
        
    }
    
    func testCleanup() {
        // doesn't do anything yet
    }

}
