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


func ==(a: Account, b: Account) -> Bool {
    return a.id == b.id
        && a.name == b.name
        && a.priority == b.priority
        && a.inactive == b.inactive
}

class Account: Model, Printable {
    
    let modelType = ModelType.Account
    
    let id: Int64?
    
    let name: String
    let priority: Int
    let inactive: Bool
    
    let pf: PFObject?
    
    var description: String {
        return "Account(id: \(id), name: \(name), priority: \(priority), inactive: \(inactive), pf: \(pf))"
    }
    
    required init(id: Int64?, name: String, priority: Int, inactive: Bool, pf: PFObject? = nil) {
        self.id = id
        self.name = name
        self.priority = priority
        self.inactive = inactive
        self.pf = pf
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(Fields.id),
            name: row.get(Fields.name),
            priority: row.get(Fields.priority),
            inactive: row.get(Fields.inactive))
    }
    
    convenience init(pf: PFObject) {
        self.init(
            id: pf.objectId.flatMap { Services.get(ParseService.self).withParseId($0, ModelType.Account) }?.modelId,
            name: pf["name"] as! String,
            priority: pf["priority"] as! Int,
            inactive: pf["inactive"] as! Bool,
            pf: pf)
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.name <- name,
            Fields.priority <- priority,
            Fields.inactive <- inactive
        ]
    }
    
    func toPFObject() -> PFObject? {
        if id != nil {
            let npf = PFObject(withoutDataWithClassName: modelType.rawValue, objectId: pf?.objectId ?? parse()?.parseId)
            npf["name"] = name
            npf["priority"] = priority
            npf["inactive"] = inactive
            return npf
        }
        return nil
    }
    
    func parse() -> ParseModel? {
        return id.flatMap { Services.get(ParseService.self).withModelId($0, modelType) }
    }
    
    func copy(name: String? = nil, priority: Int? = nil, inactive: Bool? = nil) -> Account {
        return Account(
            id: id,
            name: name ?? self.name,
            priority: priority ?? self.priority,
            inactive: inactive ?? self.inactive)
    }
    
}