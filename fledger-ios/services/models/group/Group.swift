//
//  Item.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite
import Parse


func ==(a: Group, b: Group) -> Bool {
    return a.id == b.id
        && a.name == b.name
}

class Group: Model, Printable {
    
    let modelType = ModelType.Group
    
    let id: Int64?
    
    let name: String
    
    let pf: PFObject?
    
    var description: String {
        return "Group(id: \(id), name: \(name), pf: \(pf))"
    }
    
    required init(id: Int64?, name: String, pf: PFObject? = nil) {
        self.id = id
        self.name = name
        self.pf = pf
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(Fields.id),
            name: row.get(Fields.name))
    }
    
    convenience init(pf: PFObject) {
        self.init(
            id: pf.objectId.flatMap { ParseSvc().withParseId($0, ModelType.Group) }?.modelId,
            name: pf["name"] as! String,
            pf: pf)
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.name <- name
        ]
    }
    
    func toPFObject() -> PFObject? {
        if id != nil {
            let npf = PFObject(withoutDataWithClassName: modelType.rawValue, objectId: pf?.objectId ?? parse()?.parseId)
            npf["name"] = name
            return npf
        }
        return nil
    }
    
    func parse() -> ParseModel? {
        return id.flatMap { ParseSvc().withModelId($0, modelType) }
    }
    
    func copy(name: String? = nil) -> Group {
        return Group(
            id: id,
            name: name ?? self.name)
    }
    
}