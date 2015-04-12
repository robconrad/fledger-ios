//
//  Item.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

class Type: Model {
    
    let id: Int64?
    
    let name: String
    
    required init(id: Int64, name: String) {
        self.id = id
        self.name = name
    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(fields.id),
            name: row.get(fields.name))
    }
    
}