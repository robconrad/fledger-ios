//
//  ParseService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/10/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import Parse

typealias ParseId = String

protocol ParseService: Service {
    
    func select(filters: ParseFilters?) -> [ParseModel]
    
    func withModelId(id: Int64, _ modelType: ModelType) -> ParseModel?
    
    func withParseId(id: String, _ modelType: ModelType) -> ParseModel?
    
    func markSynced(id: Int64, _ modelType: ModelType, _ pf: PFObject) -> Bool
    
    func save(convertible: PFObjectConvertible) -> PFObject?
    
    func remote(modelType: ModelType, updatedOnly: Bool) -> [PFObject]?
    
    func syncAllToRemote()
    func syncAllToRemoteInBackground()
    
    func syncAllFromRemote()
    func syncAllFromRemoteInBackground()
    
    func notifySyncListeners(syncType: ParseSyncType)
    func registerSyncListener(listener: ParseSyncListener)
    func ungregisterSyncListener(listener: ParseSyncListener)
    
}

func ==(lhs: ParseSyncListener, rhs: ParseSyncListener) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

class ParseSyncListener: Hashable {
    let hashValue = Int(arc4random()) // Fuck it. I don't care.
    func notify(syncType: ParseSyncType) {
        fatalError("FUCK SWIFT FOR NOT LETTING ME HAVE A HASHABLE PROTOCOL")
    }
}

enum ParseSyncType {
    case To
    case From
}