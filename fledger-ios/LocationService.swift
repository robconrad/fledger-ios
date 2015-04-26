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
    
}