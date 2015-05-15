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


func ==(a: Type, b: Type) -> Bool {
    return a.id == b.id
        && a.groupId == b.groupId
        && a.name == b.name
}

class Type: Model, Printable {
    
    let modelType = ModelType.Typ
    
    let id: Int64?
    let groupId: Int64
    
    let name: String
    
    let pf: PFObject?
    
    var description: String {
        return "Type(id: \(id), groupId: \(groupId), name: \(name), pf: \(pf))"
    }
    
    required init(id: Int64?, groupId: Int64, name: String, pf: PFObject? = nil) {
        self.id = id
        self.groupId = groupId
        self.name = name
        self.pf = pf
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(Fields.id),
            groupId: row.get(Fields.groupId),
            name: row.get(Fields.name))
    }
    
    convenience init(pf: PFObject) {
        self.init(
            id: pf.objectId.flatMap { Services.get(ParseService.self).withParseId($0, ModelType.Typ) }?.modelId,
            groupId: Services.get(ParseService.self).withParseId(pf["groupId"] as! String, ModelType.Group)!.modelId,
            name: pf["name"] as! String,
            pf: pf)
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.name <- name,
            Fields.groupId <- groupId
        ]
    }
    
    func toPFObject() -> PFObject? {
        if id != nil {
            let npf = PFObject(withoutDataWithClassName: modelType.rawValue, objectId: pf?.objectId ?? parse()?.parseId)
            npf["name"] = name
            npf["groupId"] = Services.get(GroupService.self).withId(groupId)?.parse()!.parseId!
            return npf
        }
        return nil
    }
    
    func parse() -> ParseModel? {
        return id.flatMap { Services.get(ParseService.self).withModelId($0, modelType) }
    }
    
    func copy(groupId: Int64? = nil, name: String? = nil) -> Type {
        return Type(
            id: id,
            groupId: groupId ?? self.groupId,
            name: name ?? self.name)
    }
    
    func group() -> Group {
        return Services.get(GroupService.self).withTypeId(id!)!
    }
    
}