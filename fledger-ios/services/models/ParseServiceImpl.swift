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
    
    func select(filters: ParseFilters?) -> [ParseModel] {
        var query = DatabaseSvc().parse
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
        return DatabaseSvc().parse.filter(Fields.model == modelType.rawValue && Fields.modelId == id).first.map { ParseModel(row: $0) }
    }
    
    func withParseId(id: String, _ modelType: ModelType) -> ParseModel? {
        return DatabaseSvc().parse.filter(Fields.model == modelType.rawValue && Fields.parseId == id).first.map { ParseModel(row: $0) }
    }
    
    func markSynced(id: Int64, _ modelType: ModelType, _ pf: PFObject) -> Bool {
        let query = DatabaseSvc().parse.filter(Fields.model == modelType.rawValue && Fields.modelId == id)
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
    
    // TODO: ***REMOVED***
    func remote(modelType: ModelType, updatedOnly: Bool) -> [PFObject]? {
        let lastSyncedRow = DatabaseSvc().parse.filter(Fields.model == modelType.rawValue).order(Fields.updatedAt.desc).first
        var bufferRows = [String]()
        var query = PFQuery(className: modelType.rawValue)
        if let lastRow = lastSyncedRow {
            let lastDateFactory = NSDate.dateByAddingTimeInterval(lastRow.get(Fields.updatedAt)?.date ?? NSDate(timeIntervalSince1970: 0))
            let updatedAtLeast = lastDateFactory(-60)
            
            for row in DatabaseSvc().parse.filter(Fields.model == modelType.rawValue && Fields.updatedAt >= NSDateTime(updatedAtLeast)) {
                if let id = row.get(Fields.parseId) {
                    bufferRows.append(id)
                }
            }
            
            // query for records within one minute of the last updated record that are not themselves the last updated record
            query.whereKey("updatedAt", greaterThanOrEqualTo: updatedAtLeast)
            query.whereKey("objectId", notContainedIn: [lastRow.get(Fields.parseId) ?? ""])
        }
        var result = query.findObjects() as? [PFObject]
        println("Remote query for PFObjects of \(modelType) lastSyncedRow (\(lastSyncedRow.flatMap { $0.get(Fields.updatedAt)?.date }), \(lastSyncedRow?.get(Fields.parseId))) returned \(result?.count ?? 0) rows")
        
        for parseId in bufferRows {
            //result!.find { $0.parseId == parseId }
        }
        
        return result
    }
    
    func syncAllToRemote() {
        // order matters because of FK resolution
        LocationSvc().syncToRemote()
        GroupSvc().syncToRemote()
        TypeSvc().syncToRemote()
        AccountSvc().syncToRemote()
        ItemSvc().syncToRemote()
    }
    
    func syncAllToRemoteInBackground() {
        syncToRemoteQueue.cancelAllOperations()
        syncToRemoteQueue.addOperation(SyncAllToRemoteOperation())
    }
    
    func syncAllFromRemote() {
        // order matters because of FK resolution
        LocationSvc().syncFromRemote()
        GroupSvc().syncFromRemote()
        TypeSvc().syncFromRemote()
        AccountSvc().syncFromRemote()
        ItemSvc().syncFromRemote()
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
        ParseSvc().syncAllToRemote()
        ParseSvc().notifySyncListeners(.To)
    }
}

class SyncAllFromRemoteOperation: NSOperation {
    override func main() {
        if self.cancelled {
            return
        }
        ParseSvc().syncAllFromRemote()
        ParseSvc().notifySyncListeners(.From)
    }
}
