//
//  LocationServiceTest.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/1/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import XCTest
import Quick
import Nimble
import fledger_ios


class LocationServiceImplTest: QuickSpec {
    override func spec() {
        let db = DatabaseServiceMock()
        Services.register(DatabaseService.self, db)
        
        let service = LocationServiceImpl()

        describe("a location service") {
            let coordinate = CLLocationCoordinate2D(latitude: 10, longitude: 10)
            let location = Location(id: nil, name: "name", coordinate: coordinate, address: "address", distance: nil)
            let location2 = location.copy(name: "name2", address: "address2")
            
            beforeEach {
                let deleted: Int = db.locations.delete()!
                println("deleted: \(deleted)")
            }
            
            describe("its ModelType") {
                it("is Location") {
                    expect(service.modelType()) == ModelType.Location
                }
            }
            
            describe("getting a Location") {
                context("by id") {
                    let id = service.insert(location)
                    let result = service.withId(id!)
                    expect(location.withId(id)) == result!
                }
            }
            
            describe("inserting a Location") {
                context("fresh") {
                    let id = service.insert(location)
                    it("returns an id") {
                        expect(id).notTo(beNil())
                    }
                    it("can be retreived") {
                        expect(service.withId(id!)) == location.withId(id)
                    }
                }
                context("second item") {
                    let id = service.insert(location2)
                    it("returns an id") {
                        expect(id).notTo(beNil())
                    }
                    it("can be retreived") {
                        expect(service.withId(id!)) == location2.withId(id)
                    }
                }
                context("with a duplicate name") {
                    let id = service.insert(location.copy(name: "unique name"))
                    it("returns no id") {
                        expect(id).to(beNil())
                    }
                }
                context("with a duplicate address") {
                    let id = service.insert(location.copy(address: "unique addy"))
                    it("returns no id") {
                        expect(id).to(beNil())
                    }
                }
            }
            
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

}
