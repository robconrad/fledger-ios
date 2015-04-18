//
//  TypeService.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class TypeService<T: Type>: MemoryModelService<Type> {
    
    override func modelType() -> ModelType {
        return ModelType.Typ
    }
    
    override internal func table() -> Query {
        return DatabaseService.main.types
    }
    
    override func defaultOrder(query: Query) -> Query {
        return query.order(Fields.name)
    }
    
    override func select(filters: Filters?) -> [Type] {
        var elements: [Type] = []
        
        for row in baseQuery(filters: filters) {
            elements.append(Type(row: row))
        }
        
        return elements
    }
    
}