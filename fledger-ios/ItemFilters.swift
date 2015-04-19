//
//  ItemFilters.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

class ItemFilters: Filters {
    
    var accountId: Int64?
    var startDate: NSDate?
    var endDate: NSDate?
    var typeId: Int64?
    var groupId: Int64?
    
    override func toQuery(var query: Query) -> Query {
        
        query = super.toQuery(query)
        
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
            s.append("Filtered by Account: " + ModelServices.account.withId(id)!.name)
        }
        if let id = typeId {
            s.append("Filtered by Type: " + ModelServices.type.withId(id)!.name)
        }
        if let id = groupId {
            s.append("Filtered by Group: " + ModelServices.group.withId(id)!.name)
        }
        if let date = startDate {
            s.append("Filtered by Start Date: " + date.datatypeValue)
        }
        if let date = endDate {
            s.append("Filtered by End Date: " + date.datatypeValue)
        }
        
        return s
    }
    
    func count() -> Int {
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

func ItemFiltersFromDefaults() -> ItemFilters {
    let filters = ItemFilters()
    
    filters.accountId = (NSUserDefaults.standardUserDefaults().valueForKey("filters.accountId") as? NSNumber)?.longLongValue
    filters.startDate = NSUserDefaults.standardUserDefaults().valueForKey("filters.startDate") as? NSDate
    filters.endDate = NSUserDefaults.standardUserDefaults().valueForKey("filters.endDate") as? NSDate
    filters.typeId = (NSUserDefaults.standardUserDefaults().valueForKey("filters.typeId") as? NSNumber)?.longLongValue
    filters.groupId = (NSUserDefaults.standardUserDefaults().valueForKey("filters.groupId") as? NSNumber)?.longLongValue
    
    return filters
}
