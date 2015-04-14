//
//  Manager.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

protocol ModelService {
    
    typealias T: Model
    
    func withId(id: Int64) -> T?
    
    func all() -> [T]
    func select(filters: Filters?) -> [T]
    
    func count(filters: Filters?) -> Int
    
    func insert(e: T) -> Int64?
    
    func update(e: T) -> Bool
    
    func delete(e: T) -> Bool
    func delete(id: Int64) -> Bool
    
    func invalidate()
    
}