//
//  Aggregates.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import SQLite


protocol AggregateService: Service {
    
    func getAll() -> [Aggregate]
    func getAccounts() -> [Aggregate]
    func getGroups() -> [Aggregate]
    func getTypes() -> [Aggregate]
    
}