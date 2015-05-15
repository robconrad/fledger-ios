//
//  Fields.swift
//  fledger-ios
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
    static let locationId = Expression<Int64?>("location_id")
    
    // common
    static let name = Expression<String>("name")
    static let nameOpt = Expression<String?>("name")
    
    // items
    static let amount = Expression<Double>("amount")
    static let comments = Expression<String>("comments")
    static let date = Expression<NSDate>("date")
    
    // locations
    static let latitude = Expression<Double>("latitude")
    static let longitude = Expression<Double>("longitude")
    static let address = Expression<String>("address")
    
    // accounts
    static let priority = Expression<Int>("priority")
    static let inactive = Expression<Bool>("inactive")
    
    // parse
    static let model = Expression<String>("model")
    static let modelId = Expression<Int64>("model_id")
    static let parseId = Expression<String?>("parse_id")
    static let synced = Expression<Bool>("synced")
    static let deleted = Expression<Bool>("deleted")
    static let updatedAt = Expression<NSDateTime?>("updated_at")
    
}

class Expressions {
    
    static let sumAmount = sum(Expression<Double?>("amount"))
    
}