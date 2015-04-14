//
//  File.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class AccountService<T: Account>: MemoryModelService<Account> {
    
    override internal func table() -> Query {
        return DatabaseService.main.accounts
    }
    
    override func defaultOrder(query: Query) -> Query {
        return query.order(Fields.priority)
    }
    
    override func select(filters: Filters?) -> [Account] {
        var elements: [Account] = []
        
        for row in baseQuery(filters: filters) {
            elements.append(Account(row: row))
        }
        
        return elements
    }
    
}