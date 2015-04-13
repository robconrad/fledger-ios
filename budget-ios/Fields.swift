//
//  Fields.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class Fields {
    
    // PK
    static let id = Expression<Int64>("id")
    
    // FKs
    static let typeId = Expression<Int64>("type_id")
    static let groupId = Expression<Int64>("group_id")
    static let accountId = Expression<Int64>("account_id")
    
    // items
    static let flow = Expression<Double>("flow")
    static let amount = Expression<Double>("amount")
    static let comments = Expression<String>("comments")
    static let date = Expression<NSDate>("date")
    
    // accounts
    static let name = Expression<String>("name")
    static let priority = Expression<Int>("priority")
    static let inactive = Expression<Bool>("inactive")
    
}

class Expressions {
    
    static let sumAmount = sum(Fields.amount * Fields.flow)
    
}