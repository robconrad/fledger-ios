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

    lazy var service: LocationServiceImpl<Location> = {
        Services.register(DatabaseService.self, DatabaseServiceMock())
        DatabaseSvc().createDatabaseDestructive()
        
        Services.register(ParseService.self, ParseServiceMock())
        
        let service = LocationServiceImpl()
        Services.register(LocationService.self, service)
        
        return service
    }()
    
    let location: Location = {
        let coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)
        return Location(id: nil, name: "name", coordinate: coordinate, address: "address")
    }()

    func testModelType() {
        XCTAssertEqual(service.modelType(), ModelType.Location)
    }
    
    func testWithId() {
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
        let id = service.insert(location)
        let result = service.all()
        XCTAssertEqual([location.withId(id)], result)
        
        let location2 = location.copy(name: "name2", address: "address2")
        let id2 = service.insert(location2)
        let result2 = service.all()
        // default order specified in LocationServiceImpl is Fields.name.ASC, name2 follows name
        XCTAssertEqual([location.withId(id), location2.withId(id2)], result2)
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
    
    func testSync() {
//        let coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)
//        let location = Location(id: nil, name: "a location", coordinate: coordinate, address: "an address")
//        let locationId = LocationSvc().insert(location)
//        
//        let group = Group(id: nil, name: "a group")
//        let groupId = GroupSvc().insert(group)!
//        
//        let type = Type(id: nil, groupId: groupId, name: "a type")
//        let typeId = TypeSvc().insert(type)!
//        
//        let account = Account(id: nil, name: "an account", priority: 0, inactive: false)
//        let accountId = AccountSvc().insert(account)!
//        
//        let item = Item(id: nil, accountId: accountId, typeId: typeId, locationId: locationId, amount: 1, date: NSDate(), comments: "a comment")
//        let itemId = ItemSvc().insert(item)!
//        
//        ParseSvc().syncAllToRemote()
//        ParseSvc().syncAllFromRemote()
//        
//        let (rows1, stmt1) = DatabaseSvc().parse.delete()
//        let (rows2, stmt2) = DatabaseSvc().locations.delete()
//        let (rows3, stmt3) = DatabaseSvc().groups.delete()
//        let (rows4, stmt4) = DatabaseSvc().types.delete()
//        let (rows5, stmt5) = DatabaseSvc().accounts.delete()
//        let (rows6, stmt6) = DatabaseSvc().items.delete()
//        
//        ParseSvc().syncAllFromRemote()
//        ParseSvc().syncAllFromRemote()
    }

}
