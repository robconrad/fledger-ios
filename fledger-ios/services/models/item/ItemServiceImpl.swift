//
//  ItemService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class ItemServiceImpl<M: Group>: StandardModelServiceImpl<Item>, ItemService {
    
    private let id: Expression<Int64>
    
    required init() {
        id = Services.get(DatabaseService.self).items[Fields.id]
        super.init()
    }
    
    override func modelType() -> ModelType {
        return ModelType.Item
    }
    
    override internal func table() -> Query {
        return dbService.items.join(dbService.types, on: Fields.typeId == dbService.types[Fields.id])
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
            Fields.typeId == Services.get(TypeService.self).transferId
        ).first.map { Item(row: $0) }
    }
    
    func getSum(item: Item, filters: Filters) -> Double {
        return baseQuery(filters: filters, limit: false)
            .filter(
                Fields.date < item.date ||
                (Fields.date == item.date && id <= item.id!))
            .sum(Fields.amount) ?? 0
    }
    
}