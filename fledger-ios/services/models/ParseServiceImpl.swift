//
//  ParseService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/10/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import SQLite
import Parse


class ParseServiceImpl: ParseService {
    
    internal let dbService: DatabaseService
    
    internal let db: Database
    internal let parse: Query
    
    private var syncListeners = Set<ParseSyncListener>()
    
    private let syncToRemoteQueue: NSOperationQueue = {
        var q = NSOperationQueue()
        q.name = "ParseService SyncTo Background Queue"
        q.maxConcurrentOperationCount = 1
        return q
        }()
    
    private let syncFromRemoteQueue: NSOperationQueue = {
        var q = NSOperationQueue()
        q.name = "ParseService SyncFrom Background Queue"
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    required init() {
        self.dbService = Services.get(DatabaseService.self)
        self.db = dbService.db
        self.parse = dbService.parse
    }
    
    func select(filters: ParseFilters?) -> [ParseModel] {
        var query = parse
        if let f = filters {
            query = f.toQuery(query, limit: true)
        }
        
        var elements: [ParseModel] = []
        
        for row in query {
            elements.append(ParseModel(row: row))
        }
        
        return elements
    }
    
    func withModelId(id: Int64, _ modelType: ModelType) -> ParseModel? {
        return parse.filter(Fields.model == modelType.rawValue && Fields.modelId == id).first.map { ParseModel(row: $0) }
    }
    
    func withParseId(id: String, _ modelType: ModelType) -> ParseModel? {
        return parse.filter(Fields.model == modelType.rawValue && Fields.parseId == id).first.map { ParseModel(row: $0) }
    }
    
    func markSynced(id: Int64, _ modelType: ModelType, _ pf: PFObject) -> Bool {
        let query = parse.filter(Fields.model == modelType.rawValue && Fields.modelId == id)
        let (rows, stmt) = query.update([
            Fields.synced <- true,
            Fields.parseId <- pf.objectId!,
            Fields.updatedAt <- NSDateTime(pf.updatedAt!)
        ])
        if rows == 1 {
            return true
        }
        else {
            fatalError("markSynced failed with rows \(rows) and \(stmt)")
        }
    }
    
    func save(convertible: PFObjectConvertible) -> PFObject? {
        if var pf = convertible.toPFObject() {
            pf.ACL = PFACL(user: PFUser.currentUser()!)
            let result = pf.save()
            println("Save of PFObject for \(convertible) returned \(pf.objectId)")
            return pf
        }
        return nil
    }
    
    func remote(modelType: ModelType, updatedOnly: Bool) -> [PFObject]? {
        let updatedAtLeast = parse.filter(Fields.model == modelType.rawValue).max(Fields.updatedAt)?.date ?? NSDate(timeIntervalSince1970: 0)
        var query = PFQuery(className: modelType.rawValue)
        query.whereKey("updatedAt", greaterThanOrEqualTo: updatedAtLeast)
        let result = query.findObjects() as? [PFObject]
        println("Remote query for PFObjects of \(modelType) updatedAtLeast \(updatedAtLeast) returned \(result?.count ?? 0) rows")
        return result
    }
    
    func syncAllToRemote() {
        // order matters because of FK resolution
        Services.get(LocationService.self).syncToRemote()
        Services.get(GroupService.self).syncToRemote()
        Services.get(TypeService.self).syncToRemote()
        Services.get(AccountService.self).syncToRemote()
        Services.get(ItemService.self).syncToRemote()
    }
    
    func syncAllToRemoteInBackground() {
        syncToRemoteQueue.cancelAllOperations()
        syncToRemoteQueue.addOperation(SyncAllToRemoteOperation())
    }
    
    func syncAllFromRemote() {
        // order matters because of FK resolution
        Services.get(LocationService.self).syncFromRemote()
        Services.get(GroupService.self).syncFromRemote()
        Services.get(TypeService.self).syncFromRemote()
        Services.get(AccountService.self).syncFromRemote()
        Services.get(ItemService.self).syncFromRemote()
    }
    
    func syncAllFromRemoteInBackground() {
        syncFromRemoteQueue.cancelAllOperations()
        syncFromRemoteQueue.addOperation(SyncAllFromRemoteOperation())
    }
    
    func notifySyncListeners(syncType: ParseSyncType) {
        for listener in syncListeners {
            listener.notify(syncType)
        }
    }
    
    func registerSyncListener(listener: ParseSyncListener) {
        syncListeners.insert(listener)
    }
    
    func ungregisterSyncListener(listener: ParseSyncListener) {
        syncListeners.remove(listener)
    }
    
}

class SyncAllToRemoteOperation: NSOperation {
    override func main() {
        if self.cancelled {
            return
        }
        Services.get(ParseService.self).syncAllToRemote()
        Services.get(ParseService.self).notifySyncListeners(.To)
    }
}

class SyncAllFromRemoteOperation: NSOperation {
    override func main() {
        if self.cancelled {
            return
        }
        Services.get(ParseService.self).syncAllFromRemote()
        Services.get(ParseService.self).notifySyncListeners(.From)
    }
}
