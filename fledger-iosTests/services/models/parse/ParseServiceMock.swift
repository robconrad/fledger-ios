//
//  ParseServiceMock.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/22/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Parse


class ParseServiceMock: ParseService {
    
    func select(filters: ParseFilters?) -> [ParseModel] {
        return []
    }
    
    func withModelId(id: Int64, _ modelType: ModelType) -> ParseModel? {
        return nil
    }
    
    func withParseId(id: String, _ modelType: ModelType) -> ParseModel? {
        return nil
    }
    
    func markSynced(id: Int64, _ modelType: ModelType, _ pf: PFObject) -> Bool {
        return true
    }
    
    func save(convertible: PFObjectConvertible) -> PFObject? {
        return nil
    }
    
    func remote(modelType: ModelType, updatedOnly: Bool) -> [PFObject]? {
        return nil
    }
    
    func syncAllToRemote() {}
    func syncAllToRemoteInBackground() {}
    
    func syncAllFromRemote() {}
    func syncAllFromRemoteInBackground() {}
    
    func notifySyncListeners(syncType: ParseSyncType) {}
    func registerSyncListener(listener: ParseSyncListener) {}
    func ungregisterSyncListener(listener: ParseSyncListener) {}
    
}