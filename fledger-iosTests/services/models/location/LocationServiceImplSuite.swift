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
        Services.register(ParseService.self, ParseServiceImpl())
        
        Services.register(ItemService.self, ItemServiceImpl())
        Services.register(AccountService.self, AccountServiceImpl())
        Services.register(TypeService.self, TypeServiceImpl())
        Services.register(GroupService.self, GroupServiceImpl())
        
        let service = LocationServiceImpl()
        Services.register(LocationService.self, service)
        
        return service
    }()

    let service = LocationServiceImplSuite.service_

    func testModelType() {
        XCTAssertEqual(service.modelType(), ModelType.Location)
    }
    
    func testWithId() {
        let coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)
        let location = Location(id: nil, name: "name", coordinate: coordinate, address: "address")
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
    
    func testSync() {
        let coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)
        let location = Location(id: nil, name: "a location", coordinate: coordinate, address: "an address")
        let locationId = Services.get(LocationService.self).insert(location)
        
        let group = Group(id: nil, name: "a group")
        let groupId = Services.get(GroupService.self).insert(group)!
        
        let type = Type(id: nil, groupId: groupId, name: "a type")
        let typeId = Services.get(TypeService.self).insert(type)!
        
        let account = Account(id: nil, name: "an account", priority: 0, inactive: false)
        let accountId = Services.get(AccountService.self).insert(account)!
        
        let item = Item(id: nil, accountId: accountId, typeId: typeId, locationId: locationId, amount: 1, date: NSDate(), comments: "a comment")
        let itemId = Services.get(ItemService.self).insert(item)!
        
        Services.get(ParseService.self).syncAllToRemote()
        Services.get(ParseService.self).syncAllFromRemote()
        
        let (rows1, stmt1) = Services.get(DatabaseService.self).parse.delete()
        let (rows2, stmt2) = Services.get(DatabaseService.self).locations.delete()
        let (rows3, stmt3) = Services.get(DatabaseService.self).groups.delete()
        let (rows4, stmt4) = Services.get(DatabaseService.self).types.delete()
        let (rows5, stmt5) = Services.get(DatabaseService.self).accounts.delete()
        let (rows6, stmt6) = Services.get(DatabaseService.self).items.delete()
        
        Services.get(ParseService.self).syncAllFromRemote()
        Services.get(ParseService.self).syncAllFromRemote()
    }

}
