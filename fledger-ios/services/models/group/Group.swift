//
//  Item.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


func ==(a: Group, b: Group) -> Bool {
    return a.id == b.id
        && a.name == b.name
}

class Group: Model {
    
    let id: Int64?
    
    let name: String
    
    required init(id: Int64?, name: String) {
        self.id = id
        self.name = name
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(Fields.id),
            name: row.get(Fields.name))
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.name <- name
        ]
    }
    
    func copy(name: String? = nil) -> Group {
        return Group(
            id: id,
            name: name ?? self.name)
    }
    
}