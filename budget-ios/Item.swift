//
//  Item.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

class Item: Model {
    
    let id: Int64?
    let accountId: Int64
    let typeId: Int64
    let amount: Double
    let date: NSDate
    let comments: String
    
    required init(id: Int64?, accountId: Int64, typeId: Int64, amount: Double, date: NSDate, comments: String) {
        self.id = id
        self.accountId = accountId
        self.typeId = typeId
        self.amount = amount
        self.date = date
        self.comments = comments    }
    
    convenience init(row: Row) {
        self.init(
            id: row.get(fields.id),
            accountId: row.get(fields.accountId),
            typeId: row.get(fields.typeId),
            amount: row.get(fields.amount),
            date: row.get(fields.date),
            comments: row.get(fields.comments))
    }
    
    func toSetters() -> [Setter] {
        return [
            fields.accountId <- accountId,
            fields.typeId <- typeId,
            fields.amount <- amount,
            fields.date <- date,
            fields.comments <- comments
        ]
    }
    
    func copy(accountId: Int64? = nil, typeId: Int64? = nil, amount: Double? = nil, date: NSDate? = nil, comments: String? = nil) -> Item {
        return Item(
            id: id,
            accountId: accountId ?? self.accountId,
            typeId: typeId ?? self.typeId,
            amount: amount ?? self.amount,
            date: date ?? self.date,
            comments: comments ?? self.comments)
    }
    
    func account() -> Account {
        return accountManager.withId(accountId)!
    }
    
    func type() -> Type {
        return typeManager.withId(typeId)!
    }
    
}