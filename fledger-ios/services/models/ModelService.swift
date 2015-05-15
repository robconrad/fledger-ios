//
//  Manager.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Parse


protocol ModelService: Service {
    
    typealias T: Model
    
    /*************************************
     Note that all methods in ModelService are copy/pasted into all 
     ChildModelService protocols to get around Swift's bullshit shortcoming
     that associated types can not be specified in inherited protocols
    **************************************/
    
    func modelType() -> ModelType
    
    func fromPFObject(pf: PFObject) -> T
    
    func withId(id: Int64) -> T?
    
    func all() -> [T]
    func select(filters: Filters?) -> [T]
    
    func count(filters: Filters?) -> Int
    
    func insert(e: T) -> Int64?
    
    func update(e: T) -> Bool
    
    func delete(e: T) -> Bool
    func delete(id: Int64) -> Bool
    
    func invalidate()

    func syncToRemote()
    func syncFromRemote()
    
}
