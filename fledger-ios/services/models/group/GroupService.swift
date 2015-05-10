//
//  LocationService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/3/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation


protocol GroupService: Service {
    
    /***************************************
     BEGIN COPY PASTA FROM BASE ModelService
     ***************************************/
    func modelType() -> ModelType
    
    func withId(id: Int64) -> Group?
    
    func all() -> [Group]
    func select(filters: Filters?) -> [Group]
    
    func count(filters: Filters?) -> Int
    
    func insert(e: Group) -> Int64?
    
    func update(e: Group) -> Bool
    
    func delete(e: Group) -> Bool
    func delete(id: Int64) -> Bool
    
    func invalidate()
    /*************************************
     END COPY PASTA FROM BASE ModelService
    **************************************/

    func withTypeId(id: Int64) -> Group?
    
}