//
//  Item.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

class Type: Model {
    
    let id: Int64?
    let groupId: Int64
    
    let name: String
    
    required init(id: Int64?, groupId: Int64, name: String) {
        self.id = id
        self.groupId = groupId
        self.name = name
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(Fields.id),
            groupId: row.get(Fields.groupId),
            name: row.get(Fields.name))
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.name <- name,
            Fields.groupId <- groupId
        ]
    }
    
    func copy(groupId: Int64? = nil, name: String? = nil) -> Type {
        return Type(
            id: id,
            groupId: groupId ?? self.groupId,
            name: name ?? self.name)
    }
    
    func group() -> Group {
        return ModelServices.group.withTypeId(id!)!
    }
    
}