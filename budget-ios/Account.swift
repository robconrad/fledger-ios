//
//  Item.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

class Account: Model {
    
    let id: Int64?
    
    let name: String
    let priority: Int
    let inactive: Bool
    
    required init(id: Int64?, name: String, priority: Int, inactive: Bool) {
        self.id = id
        self.name = name
        self.priority = priority
        self.inactive = inactive
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(Fields.id),
            name: row.get(Fields.name),
            priority: row.get(Fields.priority),
            inactive: row.get(Fields.inactive))
    }
    
    func toSetters() -> [Setter] {
        return [
            Fields.name <- name,
            Fields.priority <- priority,
            Fields.inactive <- inactive
        ]
    }
    
    func copy(name: String? = nil, priority: Int? = nil, inactive: Bool? = nil) -> Account {
        return Account(
            id: id,
            name: name ?? self.name,
            priority: priority ?? self.priority,
            inactive: inactive ?? self.inactive)
    }
    
}