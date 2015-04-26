//
//  Manager.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


class StandardModelService<M: Model>: ModelService {
    
    private let parse = DatabaseService.main.parse
    private let db = DatabaseService.main.db
    
    func modelType() -> ModelType {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
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
    
    func baseQuery(filters: Filters? = nil, limit: Bool = true) -> Query {
        var query = defaultOrder(baseFilter(table()))
        
        if let f = filters {
            query = f.toQuery(query, limit: limit)
        }
        
        return query
    }
    
    func select(filters: Filters?) -> [M] {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
    func count(filters: Filters?) -> Int {
        return baseQuery(filters: filters, limit: false).count
    }
    
    func insert(e: M) -> Int64? {
        var id: Int64?
        
        let result = db.transaction { _ in
            
            let (modelId, modelStmt) = table().insert(e.toSetters())
            id = modelId
            
            if let unwrappedId = modelId {
                let (parseId, parseStmt) = parse.insert([
                    Fields.model <- modelType().string,
                    Fields.modelId <- unwrappedId
                ])
                if parseId != nil {
                    return .Commit
                }
                else {
                    println(parseStmt.reason)
                }
            }
            else {
                println(modelStmt.reason)
            }
            
            println(modelStmt)
            
            id = nil
            return .Rollback
        }
        
        if result.failed {
            return nil
        }
        return id
    }
    
    func update(e: M) -> Bool {
        var success = false
        
        let result = db.transaction { _ in
            let (modelRows, modelStmt) = table().filter(Fields.id == e.id!).update(e.toSetters())
            
            if modelRows == 1 {
                let query: Query = parse.filter(Fields.model == modelType().string && Fields.modelId == e.id!)
                let (parseRows, parseStmt) = query.update(Fields.synced <- false)
                
                if parseRows == 1 {
                    success = true
                    return .Commit
                }
                else {
                    println(parseStmt.reason)
                }
            }
            else {
                println(modelStmt.reason)
            }
            
            return .Rollback
        }
        
        if result.failed {
            return false
        }
        return success
    }
    
    func delete(e: M) -> Bool {
        return delete(e.id!)
    }
    
    func delete(id: Int64) -> Bool {
        var success = false
        
        let result = db.transaction { _ in
            let (modelRows, modelStmt) = table().filter(Fields.id == id).delete()
            
            if modelRows == 1 {
                let query: Query = parse.filter(Fields.model == modelType().string && Fields.modelId == id)
                let (parseRows, parseStmt) = query.update(Fields.synced <- false, Fields.deleted <- true)
                
                if parseRows == 1 {
                    success = true
                    return .Commit
                }
                else {
                    println(parseStmt.reason)
                }
            }
            else {
                println(modelStmt.reason)
            }
            
            return .Rollback
        }
        
        if result.failed {
            return false
        }
        return success
    }
    
    func invalidate() {
        // standard model always talks to db and thus doesn't require invalidation
    }
    
}
