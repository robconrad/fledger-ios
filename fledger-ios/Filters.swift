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
    
    var offset: Int?
    var count: Int?
    
    func toQuery(var query: Query) -> Query {
        
        let myOffset = offset ?? 0
        let myCount = count ?? Int.max
        
        return query.limit(myCount, offset: myOffset)
    }
    
}