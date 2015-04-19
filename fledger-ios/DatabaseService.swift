//
//  DatabaseService.swift
//  fledger-ios
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
    
    let db: Database
    
    let accounts: Query
    let groups: Query
    let types: Query
    let items: Query
    let parse: Query
    
    required override init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
        db = Database("\(path)/db.sqlite3")
        
        db.trace(println)
        
        accounts = db["accounts"]
        groups = db["groups"]
        types = db["types"]
        items = db["items"]
        parse = db["parse"]
        
    }
    
    func createDatabaseDestructive() {
        let schema = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("schema", withExtension: "sql")!)
        let sql = NSString(data: schema!, encoding: NSASCIIStringEncoding) as! String
        db.execute(sql)
    }
    
    func loadDefaultData() {
        let data = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("data-lite", withExtension: "sql")!)
        let sql = NSString(data: data!, encoding: NSASCIIStringEncoding) as! String
        db.execute(sql)
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
