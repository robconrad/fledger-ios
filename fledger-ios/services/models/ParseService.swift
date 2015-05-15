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
    
}