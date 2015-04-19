//
//  ItemService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class ItemService<M: Item>: StandardModelService<Item> {
    
    override func modelType() -> ModelType {
        return ModelType.Item
    }
    
    override internal func table() -> Query {
        return DatabaseService.main.items.join(DatabaseService.main.types, on: Fields.typeId == DatabaseService.main.types[Fields.id])
    }
    
    override func defaultOrder(query: Query) -> Query {
        return query.order(Fields.date.desc, table()[Fields.id].desc)
    }
    
    override func baseFilter(query: Query) -> Query {
        return query.filter(Fields.amount != 0)
    }
    
    override func select(filters: Filters?) -> [Item] {
        var elements: [Item] = []
        
        for row in baseQuery(filters: filters) {
            elements.append(Item(row: row))
        }
        
        return elements
    }
    
    func getTransferPair(first: Item) -> Item? {
        return table().filter(
            Fields.date == first.date &&
            Fields.comments == first.comments &&
            Fields.accountId != first.accountId &&
            Fields.typeId == ModelServices.type.transferId
        ).first.map { Item(row: $0) }
    }
    
}