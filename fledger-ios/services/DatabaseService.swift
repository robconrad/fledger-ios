//
//  DatabaseService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite

protocol DatabaseService: Service {
    
    var db: Database { get }
    
    var locations: Query { get }
    var accounts: Query { get }
    var groups: Query { get }
    var types: Query { get }
    var items: Query { get }
    var parse: Query { get }
    
    func createDatabaseDestructive()
    func loadDefaultData()
    func loadDefaultData(file: String)
    
}