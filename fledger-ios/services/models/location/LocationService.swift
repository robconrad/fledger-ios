//
//  TypeService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite
import MapKit


class LocationService<T: Location>: MemoryModelService<Location> {
    
    required init() {
        super.init()
    }
    
    override func modelType() -> ModelType {
        return ModelType.Location
    }
    
    override internal func table() -> Query {
        return dbService.locations
    }
    
    override func defaultOrder(query: Query) -> Query {
        return query.order(Fields.name)
    }
    
    override func select(filters: Filters?) -> [Location] {
        var elements: [Location] = []
        
        for row in baseQuery(filters: filters) {
            elements.append(Location(row: row))
        }
        
        return elements
    }
    
    func itemCount(id: Int64) -> Int {
        return dbService.items.filter(Fields.locationId == id).count
    }
    
    func nearest(coordinate: CLLocationCoordinate2D, sortBy: LocationSortBy) -> [Location] {
        
        let orderBy: String
        switch sortBy {
        case .Name: orderBy = "CASE WHEN name IS NULL THEN address ELSE name END"
        case .Distance: orderBy = "computedDistance"
        }
        
        var elements: [Location] = []
        let stmt = db.prepare("SELECT id, name, latitude, longitude, address, distance(latitude, longitude, ?, ?) AS computedDistance FROM locations ORDER BY \(orderBy)")
        
        for row in stmt.run(coordinate.latitude, coordinate.longitude) {
            elements.append(Location(
                id: (row[0] as! Int64),
                name: row[1] as? String,
                latitude: row[2] as! Double,
                longitude: row[3] as! Double,
                address: row[4] as! String,
                distance: row[5] as? Double)
            )
        }
        
        return elements
    }
    
    func cleanup() {
        // TODO delete locations that have 0 items attached
    }
    
}

enum LocationSortBy: String {
    case Name = "Name"
    case Distance = "Distance"
}