//
//  ItemFilters.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

class ItemFilters {
    
    var accountId: Int64?
    var startDate: NSDate?
    var endDate: NSDate?
    var typeId: Int64?
    
    func toQuery(var query: Query) -> Query {
        if let id = accountId {
            query = query.filter(fields.accountId == id)
        }
        if let id = typeId {
            query = query.filter(fields.typeId == id)
        }
        if let date = startDate {
            query = query.filter(fields.date >= date)
        }
        if let date = endDate {
            query = query.filter(fields.date <= date)
        }
        return query
    }
    
    func strings() -> [String] {
        var s: [String] = []
        
        if let id = accountId {
            s.append("Filtered by Account: " + accountManager.withId(id)!.name)
        }
        if let id = typeId {
            s.append("Filtered by Type: " + typeManager.withId(id)!.name)
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
    }
    
    func clear() {
        accountId = nil
        startDate = nil
        endDate = nil
        typeId = nil
    }
    
}

func ItemFiltersFromDefaults() -> ItemFilters {
    let filters = ItemFilters()
    
    filters.accountId = (NSUserDefaults.standardUserDefaults().valueForKey("filters.accountId") as? NSNumber)?.longLongValue
    filters.startDate = NSUserDefaults.standardUserDefaults().valueForKey("filters.startDate") as? NSDate
    filters.endDate = NSUserDefaults.standardUserDefaults().valueForKey("filters.endDate") as? NSDate
    filters.typeId = (NSUserDefaults.standardUserDefaults().valueForKey("filters.typeId") as? NSNumber)?.longLongValue
    
    return filters
}
