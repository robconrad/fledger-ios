//
//  LocationService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/3/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation


protocol AccountService {
    
    /***************************************
     BEGIN COPY PASTA FROM BASE ModelService
     ***************************************/
    func modelType() -> ModelType
    
    func withId(id: Int64) -> Account?
    
    func all() -> [Account]
    func select(filters: Filters?) -> [Account]
    
    func count(filters: Filters?) -> Int
    
    func insert(e: Account) -> Int64?
    
    func update(e: Account) -> Bool
    
    func delete(e: Account) -> Bool
    func delete(id: Int64) -> Bool
    
    func invalidate()
    /***************************************
    END COPY PASTA FROM BASE ModelService
    ***************************************/
    
}