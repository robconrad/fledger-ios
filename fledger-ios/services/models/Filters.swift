//
//  Filters.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

class Filters {
    
    var ids: [Int64]?
    
    var offset: Int?
    var count: Int?
    
    func toQuery(var query: Query, limit: Bool = true, table: Query? = nil) -> Query {
        
        if let myIds = ids {
            var field = Fields.id
            if let t = table {
                field = t[field]
            }
            query = query.filter(contains(myIds, field))
        }
        
        if limit && (offset != nil || count != nil) {
            let myOffset = offset ?? 0
            let myCount = count ?? Int.max
            query = query.limit(myCount, offset: myOffset)
        }
        
        return query
    }
    
}