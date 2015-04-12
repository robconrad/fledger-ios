//
//  Model.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

let model = RuntimeModel()

class RuntimeModel {
    
    private let db: Database
    
    private let accounts: Query
    private let types: Query
    private let items: Query
    
    required init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
        db = Database("\(path)/db.sqlite3")
        
        db.trace(println)
        
        accounts = db["accounts"]
        types = db["types"]
        items = db["items"]
        
    }
    
    func createDatabaseDestructive() {
        let data = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("cakebudget2", withExtension: "sql")!)
        let sql = NSString(data: data!, encoding: NSASCIIStringEncoding) as! String
        db.execute(sql)
    }
    
    func getAccounts() -> [Account] {
        var myAccounts: [Account] = []
        let query = accounts
            .order(fields.priority)
        for account in query {
            myAccounts.append(Account(row: account))
        }
        return myAccounts
    }
    
    func getTypes() -> [Type] {
        var myTypes: [Type] = []
        let query = types
            .order(fields.name)
        for type in query {
            myTypes.append(Type(row: type))
        }
        return myTypes
    }
    
    func getItems(
        offset: Int = 0,
        count: Int = 30,
        itemFilters: ItemFilters? = nil
    ) -> [Item] {
        
        var myItems: [Item] = []
        
        var query = items
            .filter(fields.amount > 0.0)
            .order(fields.date.desc, fields.id.desc)
            .limit(count, offset: offset)
        
        if let filters = itemFilters {
            query = filters.toQuery(query)
        }
        
        for item in query {
            myItems.append(Item(row: item))
        }
        
        return myItems
    }
    
    func getItemCount() -> Int {
        return items.filter(fields.amount > 0.0).count
    }
    
    func updateItem(item: Item) -> Bool {
        return items.filter(fields.id == item.id!).update(item.toSetters()) > 0
    }
    
    func insertItem(item: Item) -> Int64? {
        let (id, stmt) = items.insert(item.toSetters())
        if id == nil {
            println(stmt.reason)
        }
        return id
    }
    
}

let SQLDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    return formatter
    }()

extension NSDate: Value {
    public class var declaredDatatype: String {
        return String.declaredDatatype
    }
    public class func fromDatatypeValue(stringValue: String) -> NSDate {
        return SQLDateFormatter.dateFromString(stringValue)!
    }
    public var datatypeValue: String {
        return SQLDateFormatter.stringFromDate(self)
    }
}

