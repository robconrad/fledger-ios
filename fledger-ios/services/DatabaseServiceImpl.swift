//
//  DatabaseServiceImpl.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

class DatabaseServiceImpl: DatabaseService {
    
    static let main: DatabaseService = DatabaseServiceImpl()
    
    let db: Database
    
    let locations: Query
    let accounts: Query
    let groups: Query
    let types: Query
    let items: Query
    let parse: Query
    
    required init() {
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as! String
        db = Database("\(path)/db.sqlite3")
        
        db.trace(println)
        
        locations = db["locations"]
        accounts = db["accounts"]
        groups = db["groups"]
        types = db["types"]
        items = db["items"]
        parse = db["parse"]
        
        db.create(function: "distance", deterministic: true) { args in
            if let lat1 = args[0] as? Double, long1 = args[1] as? Double, lat2 = args[2] as? Double, long2 = args[3] as? Double {
                let piOver180 = 0.01745327
                let lat1rad = lat1 * piOver180
                let lat2rad = lat2 * piOver180
                let long1rad = long1 * piOver180
                let long2rad = long2 * piOver180
                return acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(long2rad - long1rad)) * 6378.1
            }
            return nil
        }
    }
    
    func createDatabaseDestructive() {
        let schema = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("schema", withExtension: "sql")!)
        let sql = NSString(data: schema!, encoding: NSASCIIStringEncoding) as! String
        db.execute(sql)
    }
    
    func loadDefaultData() {
        loadDefaultData("data-lite")
    }
    func loadDefaultData(file: String) {
        let data = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource(file, withExtension: "sql")!)
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

private let UIDateFormatter: NSDateFormatter = {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    formatter.timeZone = NSTimeZone.localTimeZone()
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
    public var uiValue: String {
        return UIDateFormatter.stringFromDate(self)
    }
}
