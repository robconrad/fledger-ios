//
//  ParseModel.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/16/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


// called ParseModel rather than Parse because Parse is taken by the Parse library
class ParseModel: Printable {
    
    let id: Int64
    let model: ModelType
    let modelId: Int64
    
    let parseId: String? // can only come from parse
    let synced: Bool
    let deleted: Bool
    let updatedAt: NSDate? // can only come from parse
    
    var description: String {
        return "ParseModel(id: \(id), model: \(model), modelId: \(modelId), parseId: \(parseId), synced: \(synced), deleted: \(deleted), updatedAt: \(updatedAt))"
    }
    
    required init(model: ModelType, id: Int64, modelId: Int64, parseId: String?, synced: Bool, deleted: Bool, updatedAt: NSDate?) {
        self.id = id
        self.model = model
        self.modelId = modelId
        self.parseId = parseId
        self.synced = synced
        self.deleted = deleted
        self.updatedAt = updatedAt
    }
    
    convenience init(row: Row) {
        self.init(
            model: ModelType(rawValue: row.get(Fields.model))!,
            id: row.get(Fields.id),
            modelId: row.get(Fields.modelId),
            parseId: row.get(Fields.parseId),
            synced: row.get(Fields.synced),
            deleted: row.get(Fields.deleted),
            updatedAt: row.get(Fields.updatedAt)?.date)
    }
    
}