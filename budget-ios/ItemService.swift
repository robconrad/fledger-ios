//
//  ItemService.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class ItemService<M: Item>: StandardModelService<Item> {
    
    override internal func table() -> Query {
        return DatabaseService.main.items
    }
    
    override func defaultOrder(query: Query) -> Query {
        return query.order(Fields.date.desc, Fields.id.desc)
    }
    
    override func baseFilter(query: Query) -> Query {
        return query.filter(Fields.amount > 0.0)
    }
    
    override func select(filters: Filters?) -> [Item] {
        var elements: [Item] = []
        
        for row in baseQuery(filters: filters) {
            elements.append(Item(row: row))
        }
        
        return elements
    }
    
}