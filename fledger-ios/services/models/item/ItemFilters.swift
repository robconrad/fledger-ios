//
//  ItemFilters.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


func ==(a: ItemFilters, b: ItemFilters) -> Bool {
    return a.accountId == b.accountId
        && a.startDate == b.startDate
        && a.endDate == b.endDate
        && a.typeId == b.typeId
        && a.groupId == b.groupId
        && a.count == b.count
        && a.offset == b.offset
}

class ItemFilters: Filters {
    
    var accountId: Int64?
    var startDate: NSDate?
    var endDate: NSDate?
    var typeId: Int64?
    var groupId: Int64?
    
    override func toQuery(var query: Query, limit: Bool = true, table: Query? = nil) -> Query {
        
        query = super.toQuery(query, limit: limit)
        
        if let id = accountId {
            query = query.filter(Fields.accountId == id)
        }
        if let id = typeId {
            query = query.filter(Fields.typeId == id)
        }
        if let id = groupId {
            query = query.filter(Fields.groupId == id)
        }
        if let date = startDate {
            query = query.filter(Fields.date >= date)
        }
        if let date = endDate {
            query = query.filter(Fields.date <= date)
        }
        
        return query
    }
    
    func strings() -> [String] {
        var s: [String] = []
        
        if let id = accountId {
            s.append("Filtered by Account: " + (AccountSvc().withId(id)?.name ?? "?"))
        }
        if let id = typeId {
            s.append("Filtered by Type: " + (TypeSvc().withId(id)?.name ?? "?"))
        }
        if let id = groupId {
            s.append("Filtered by Group: " + (GroupSvc().withId(id)?.name ?? "?"))
        }
        if let date = startDate {
            s.append("Filtered by Start Date: " + date.uiValue)
        }
        if let date = endDate {
            s.append("Filtered by End Date: " + date.uiValue)
        }
        
        return s
    }
    
    func countFilters() -> Int {
        return strings().count
    }
    
    func save() {
        if let id = accountId {
            NSUserDefaults.standardUserDefaults().setObject(NSNumber(longLong: id), forKey: "filters.accountId")
        }
        else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("filters.accountId")
        }
        if let date = startDate {
            NSUserDefaults.standardUserDefaults().setObject(date, forKey: "filters.startDate")
        }
        else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("filters.startDate")
        }
        if let date = endDate {
            NSUserDefaults.standardUserDefaults().setObject(date, forKey: "filters.endDate")
        }
        else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("filters.endDate")
        }
        if let id = typeId {
            NSUserDefaults.standardUserDefaults().setObject(NSNumber(longLong: id), forKey: "filters.typeId")
        }
        else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("filters.typeId")
        }
        if let id = groupId {
            NSUserDefaults.standardUserDefaults().setObject(NSNumber(longLong: id), forKey: "filters.groupId")
        }
        else {
            NSUserDefaults.standardUserDefaults().removeObjectForKey("filters.groupId")
        }
    }
    
    func addAggregate(agg: Aggregate) {
        if let model = agg.model {
            switch model {
            case .Account: accountId = agg.id
            case .Group: groupId = agg.id
            case .Typ: typeId = agg.id
            case .Location: break
            case .Item: break
            }
        }
    }
    
    func clear() {
        accountId = nil
        startDate = nil
        endDate = nil
        typeId = nil
        groupId = nil
    }
    
}
