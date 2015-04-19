//
//  TypeService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class GroupService<T: Group>: MemoryModelService<Group> {
    
    override func modelType() -> ModelType {
        return ModelType.Group
    }
    
    func withTypeId(id: Int64) -> Group? {
        if let type = ModelServices.type.withId(id) {
            return withId(type.groupId)
        }
        return nil
    }
    
    override internal func table() -> Query {
        return DatabaseService.main.groups
    }
    
    override func defaultOrder(query: Query) -> Query {
        return query.order(Fields.name)
    }
    
    override func select(filters: Filters?) -> [Group] {
        var elements: [Group] = []
        
        for row in baseQuery(filters: filters) {
            elements.append(Group(row: row))
        }
        
        return elements
    }
    
}