//
//  ParseModel.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/16/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation

class ParseModel {
    
    let model: ModelType
    let id: Int64
    
    let parseId: String? // can onyl come from parse
    let synced: Bool
    let deleted: Bool
    let updatedAt: NSDate? // can only come from parse
    
    required init(model: ModelType, id: Int64, parseId: String?, synced: Bool, deleted: Bool, updatedAt: NSDate?) {
        self.model = model
        self.id = id
        self.parseId = parseId
        self.synced = synced
        self.deleted = deleted
        self.updatedAt = updatedAt
    }
    
}