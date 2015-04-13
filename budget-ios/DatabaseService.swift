//
//  DatabaseService.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

class DatabaseService: NSObject {

    class var main: DatabaseService {
        struct Singleton {
            static let instance = DatabaseService()
        }
        return Singleton.instance
    }
    
    private let db: Database
    
    let accounts: Query
    let groups: Query
    let types: Query
    let items: Query
    
    required override init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
        db = Database("\(path)/db.sqlite3")
        
        db.trace(println)
        
        accounts = db["accounts"]
        groups = db["type_groups"]
        types = db["types"]
        items = db["items"]
        
    }
    
    func createDatabaseDestructive() {
        let data = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("cakebudget2", withExtension: "sql")!)
        let sql = NSString(data: data!, encoding: NSASCIIStringEncoding) as! String
        db.execute(sql)
    }
    
    func getItems(
        offset: Int = 0,
        count: Int = 30,
        itemFilters: ItemFilters? = nil
        ) -> [Item] {
            
            var myItems: [Item] = []
            
            var query = items
                .filter(Fields.amount > 0.0)
                .order(Fields.date.desc, Fields.id.desc)
                .limit(count, offset: offset)
            
            if let filters = itemFilters {
                query = filters.toQuery(query)
            }
            
            for item in query {
                myItems.append(Item(row: item))
            }
            
            return myItems
    }
    
}

private let SQLDateFormatter: NSDateFormatter = {
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
