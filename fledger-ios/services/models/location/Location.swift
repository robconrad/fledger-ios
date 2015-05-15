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
import Parse


func ==(a: Location, b: Location) -> Bool {
    return a.id == b.id
        && a.name == b.name
        && a.coordinate.latitude == b.coordinate.latitude
        && a.coordinate.longitude == b.coordinate.longitude
        && a.address == b.address
        && a.distance == b.distance
}

class Location: Model, Printable {
    
    let modelType = ModelType.Location
    
    let id: Int64?
    
    let name: String?
    let coordinate: CLLocationCoordinate2D
    let address: String
    let distance: Double?
    
    let pf: PFObject?
    
    var description: String {
        return "Location(id: \(id), name: \(name), coordinate: \(coordinate), address: \(address), distance: \(distance), pf: \(pf))"
    }
    
    required init(id: Int64?, name: String?, coordinate: CLLocationCoordinate2D, address: String, distance: Double? = nil, pf: PFObject? = nil) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.address = address
        self.distance = distance
        self.pf = pf
    }
    
    convenience init(id: Int64?, name: String?, latitude: Double, longitude: Double, address: String, distance: Double? = nil, pf: PFObject? = nil) {
        self.init(
            id: id,
            name: name,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            address: address,
            distance: distance,
            pf: pf)
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(Fields.id),
            name: row.get(Fields.nameOpt),
            latitude: row.get(Fields.latitude),
            longitude: row.get(Fields.longitude),
            address: row.get(Fields.address))
    }
    
    convenience init(pf: PFObject) {
        self.init(
            id: pf.objectId.flatMap { Services.get(ParseService.self).withParseId($0, ModelType.Location) }?.modelId,
            name: pf["name"] as? String,
            latitude: pf["latitude"] as! Double,
            longitude: pf["longitude"] as! Double,
            address: pf["address"] as! String,
            pf: pf)
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.nameOpt <- name,
            Fields.latitude <- coordinate.latitude,
            Fields.longitude <- coordinate.longitude,
            Fields.address <- address
        ]
    }
    
    func toPFObject() -> PFObject? {
        if id != nil {
            let npf = PFObject(withoutDataWithClassName: modelType.rawValue, objectId: pf?.objectId ?? parse()?.parseId)
            npf["name"] = name ?? NSNull()
            npf["latitude"] = coordinate.latitude.datatypeValue
            npf["longitude"] = coordinate.longitude.datatypeValue
            npf["address"] = address
            return npf
        }
        return nil
    }
    
    func parse() -> ParseModel? {
        return id.flatMap { Services.get(ParseService.self).withModelId($0, modelType) }
    }
    
    func copy(name: String? = nil, coordinate: CLLocationCoordinate2D? = nil, address: String? = nil) -> Location {
        return Location(
            id: id,
            name: name ?? self.name,
            coordinate: coordinate ?? self.coordinate,
            address: address ?? self.address)
    }
    
    func withId(id: Int64?) -> Location {
        return Location(
            id: id,
            name: name,
            coordinate: coordinate,
            address: address,
            distance: distance)
    }
    
    func title() -> String {
        return name ?? address
    }
    
}