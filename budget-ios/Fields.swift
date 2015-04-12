//
//  Fields.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

let fields = Fields()

struct Fields {
    
    // PK
    let id = Expression<Int64>("id")
    
    // FKs
    let typeId = Expression<Int64>("type_id")
    let accountId = Expression<Int64>("account_id")
    
    // items
    let amount = Expression<Double>("amount")
    let comments = Expression<String>("comments")
    let date = Expression<NSDate>("date")
    
    // accounts
    let name = Expression<String>("name")
    let priority = Expression<Int>("priority")
    let inactive = Expression<Bool>("inactive")
    
}