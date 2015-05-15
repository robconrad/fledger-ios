//
//  LocationService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/3/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import Parse


protocol LocationService: Service {
    
    /***************************************
     BEGIN COPY PASTA FROM BASE ModelService
     ***************************************/
    func modelType() -> ModelType
    
    func fromPFObject(pf: PFObject) -> Location
    
    func withId(id: Int64) -> Location?
    
    func all() -> [Location]
    func select(filters: Filters?) -> [Location]
    
    func count(filters: Filters?) -> Int
    
    func insert(e: Location) -> Int64?
    
    func update(e: Location) -> Bool
    
    func delete(e: Location) -> Bool
    func delete(id: Int64) -> Bool
    
    func invalidate()
    
    func syncToRemote()
    func syncFromRemote()
    /*************************************
     END COPY PASTA FROM BASE ModelService
    **************************************/
    
    func itemCount(id: Int64) -> Int
    
    func nearest(coordinate: CLLocationCoordinate2D, sortBy: LocationSortBy) -> [Location]
    
    func cleanup()
    
}

enum LocationSortBy: String {
    case Name = "Name"
    case Distance = "Distance"
}