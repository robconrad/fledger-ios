//
//  File.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class AccountService<T: Account>: MemoryModelService<Account> {
    
    required init() {
        super.init()
    }
    
    override func modelType() -> ModelType {
        return ModelType.Account
    }
    
    override internal func table() -> Query {
        return dbService.accounts
    }
    
    override func defaultOrder(query: Query) -> Query {
        return query.order(Fields.priority, Fields.name)
    }
    
    override func select(filters: Filters?) -> [Account] {
        var elements: [Account] = []
        
        for row in baseQuery(filters: filters) {
            elements.append(Account(row: row))
        }
        
        return elements
    }
    
}