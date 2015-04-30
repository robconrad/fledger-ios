//
//  TypeService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class LocationService<T: Location>: MemoryModelService<Location> {
    
    override func modelType() -> ModelType {
        return ModelType.Location
    }
    
    override internal func table() -> Query {
        return DatabaseService.main.locations
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
        return DatabaseService.main.items.filter(Fields.locationId == id).count
    }
    
    func nearest(coordinate: CLLocationCoordinate2D) -> [Location] {
        
        var elements: [Location] = []
        let stmt = DatabaseService.main.db.prepare("SELECT id, name, latitude, longitude, address, distance(latitude, longitude, ?, ?) AS computedDistance FROM locations ORDER BY computedDistance")
        
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