//
//  Manager.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite
import Parse


class StandardModelServiceImpl<M: Model>: ModelService {
    
    internal let dbService: DatabaseService
    internal let parseService: ParseService

    internal let db: Database
    internal let parse: Query
    
    required init() {
        self.dbService = Services.get(DatabaseService.self)
        self.parseService = Services.get(ParseService.self)
        self.db = dbService.db
        self.parse = dbService.parse
    }
    
    func modelType() -> ModelType {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
    // I hate Swift.
    // When this is implemented properly in the end ModelService classes it generates EXC_BAD_ACCESS for no goddamn reason.
    func fromPFObject(pf: PFObject) -> M {
        switch modelType() {
        case .Location: return Location(pf: pf) as! M
        case .Group: return Group(pf: pf) as! M
        case .Typ: return Type(pf: pf) as! M
        case .Account: return Account(pf: pf) as! M
        case .Item: return Item(pf: pf) as! M
        }
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
            query = f.toQuery(query, limit: limit, table: table())
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
        return insert(e, fromRemote: false)
    }
    
    internal func insert(e: M, fromRemote: Bool) -> Int64? {
        var id: Int64?
        
        if fromRemote {
            assert(e.pf != nil, "pf may not be empty if insert is fromRemote")
        }
        
        let result = db.transaction { _ in
            
            let (modelId, modelStmt) = table().insert(e.toSetters())
            id = modelId
            
            if let unwrappedId = modelId {
                let (parseId, parseStmt) = parse.insert([
                    Fields.model <- modelType().rawValue,
                    Fields.modelId <- unwrappedId,
                    Fields.parseId <- e.pf?.objectId,
                    Fields.synced <- fromRemote,
                    Fields.deleted <- false,
                    Fields.updatedAt <- e.pf?.updatedAt.map { NSDateTime($0) }
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
            println("insert failed with \(result.reason)")
            return nil
        }
        
        if !fromRemote {
            parseService.syncAllToRemoteInBackground()
        }
        
        return id
    }
    
    func update(e: M) -> Bool {
        return update(e, fromRemote: false)
    }
    
    internal func update(e: M, fromRemote: Bool) -> Bool {
        var success = false
        
        let result = db.transaction { _ in
            let (modelRows, modelStmt) = table().filter(Fields.id == e.id!).update(e.toSetters())
            
            if modelRows == 1 {
                let query: Query = parse.filter(Fields.model == modelType().rawValue && Fields.modelId == e.id!)
                var setters = [Fields.synced <- fromRemote]
                if let parseId = e.pf?.objectId, updatedAt = e.pf?.updatedAt {
                    setters.append(Fields.parseId <- parseId)
                    setters.append(Fields.updatedAt <- NSDateTime(updatedAt))
                }
                let (parseRows, parseStmt) = query.update(setters)
                
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
            println("update failed with \(result.reason)")
            return false
        }
        
        if !fromRemote {
            parseService.syncAllToRemoteInBackground()
        }
        
        if !success {
            println("hi")
        }
        
        return success
    }
    
    func delete(e: M) -> Bool {
        return delete(e.id!)
    }
    
    func delete(id: Int64) -> Bool {
        return delete(id, fromRemote: false)
    }
    
    internal func delete(id: Int64, fromRemote: Bool, updatedAt: NSDate? = nil) -> Bool {
        var success = false
        
        let result = db.transaction { _ in
            let (modelRows, modelStmt) = table().filter(Fields.id == id).delete()
            
            if modelRows == 1 {
                let query: Query = parse.filter(Fields.model == modelType().rawValue && Fields.modelId == id)
                var setters = [
                    Fields.synced <- fromRemote,
                    Fields.deleted <- true
                ]
                if let date = updatedAt {
                    setters.append(Fields.updatedAt <- NSDateTime(date))
                }
                let (parseRows, parseStmt) = query.update(setters)
                
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
            println("delete failed with \(result.reason)")
            return false
        }
        
        if !fromRemote {
            parseService.syncAllToRemoteInBackground()
        }
        
        return success
    }
    
    func invalidate() {
        // standard model always talks to db and thus doesn't require invalidation
    }
    
    func syncToRemote() {
        let parseFilters = ParseFilters()
        parseFilters.synced = false
        parseFilters.modelType = modelType()
        let parseModels = parseService.select(parseFilters)
        
        let modelFilters = Filters()
        modelFilters.ids = Set(parseModels.filter { !$0.deleted }.map { $0.modelId })
        for model in select(modelFilters) {
            if let pf = parseService.save(model) {
                parseService.markSynced(model.id!, modelType(), pf)
            }
        }
        
        let deletedModels = parseModels.filter { $0.deleted }.map { DeletedModel(id: $0.modelId, parseId: $0.parseId!, modelType: self.modelType()) }
        for model in deletedModels {
            if let pf = parseService.save(model) {
                parseService.markSynced(model.id, modelType(), pf)
            }
        }
    }
    
    func syncFromRemote() {
        var pfObjects: [PFObject] = parseService.remote(modelType(), updatedOnly: true) ?? []
        // sort by date ascending so that we don't miss any if this gets interrupted and we try syncIncoming again
        pfObjects.sort { ($0.updatedAt ?? NSDate()).compare($1.updatedAt!) == .OrderedAscending }
        let models = pfObjects.map { self.fromPFObject($0) }
        for i in 0..<pfObjects.count {
            let model = models[i]
            if model.id == nil {
                if let id = insert(model, fromRemote: true) {
                    if (pfObjects[i]["deleted"] as? Bool) == true {
                        if !delete(id, fromRemote: true) {
                            fatalError(__FUNCTION__ + " failed to delete \(model)")
                        }
                    }
                }
                else {
                    fatalError(__FUNCTION__ + " failed to insert \(model)")
                }
            }
            else {
                if (pfObjects[i]["deleted"] as? Bool) == true {
                    if !delete(model.id!, fromRemote: true, updatedAt: pfObjects[i].updatedAt) {
                        fatalError(__FUNCTION__ + " failed to delete \(model)")
                    }
                }
                else {
                    if update(model, fromRemote: true) {
                        fatalError(__FUNCTION__ + " failed to update \(model)")
                    }
                }
            }
        }
        
        invalidate()
    }
    
}
