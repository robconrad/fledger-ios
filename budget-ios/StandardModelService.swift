//
//  Manager.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class StandardModelService<M: Model>: ModelService {
    
    internal func table() -> Query {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
    func withId(id: Int64) -> M? {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
    func all() -> [M] {
        return select(nil)
    }
    
    func defaultOrder(query: Query) -> Query {
        return query.order(Fields.id.desc)
    }
    
    func baseFilter(query: Query) -> Query {
        return query
    }
    
    func baseQuery(filters: Filters? = nil) -> Query {
        var query = defaultOrder(baseFilter(table()))
        
        if let f = filters {
            query = f.toQuery(query)
        }
        
        return query
    }
    
    func select(filters: Filters?) -> [M] {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
    func count(filters: Filters?) -> Int {
        return baseQuery(filters: filters).count
    }
    
    func insert(e: M) -> Int64? {
        let (id, stmt) = table().insert(e.toSetters())
        if id == nil {
            println(stmt.reason)
        }
        return id
    }
    
    func update(e: M) -> Bool {
        return table().filter(Fields.id == e.id!).update(e.toSetters()) == 1
    }
    
    func delete(e: M) -> Bool {
        return delete(e.id!)
    }
    
    func delete(id: Int64) -> Bool {
        return table().filter(Fields.id == id).delete() == 1
    }
    
    func invalidate() {
        // standard model always talks to db and thus doesn't require invalidation
    }
    
}
