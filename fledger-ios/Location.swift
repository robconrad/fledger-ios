//
//  Item.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import CoreLocation
import Foundation
import SQLite


class Location: Model {
    
    let id: Int64?
    
    let name: String?
    let coordinate: CLLocationCoordinate2D
    let address: String
    
    required init(id: Int64?, name: String?, coordinate: CLLocationCoordinate2D, address: String) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.address = address
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(Fields.id),
            name: row.get(Fields.nameOpt),
            coordinate: CLLocationCoordinate2D(latitude: row.get(Fields.latitude), longitude: row.get(Fields.longitude)),
            address: row.get(Fields.address))
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.nameOpt <- name,
            Fields.latitude <- coordinate.latitude,
            Fields.longitude <- coordinate.longitude,
            Fields.address <- address
        ]
    }
    
    func copy(name: String? = nil, coordinate: CLLocationCoordinate2D? = nil, address: String? = nil) -> Location {
        return Location(
            id: id,
            name: name ?? self.name,
            coordinate: coordinate ?? self.coordinate,
            address: address ?? self.address)
    }
    
}