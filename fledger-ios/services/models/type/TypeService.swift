//
//  LocationService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/3/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import Parse


protocol TypeService: Service {
    
    /***************************************
     BEGIN COPY PASTA FROM BASE ModelService
     ***************************************/
    func modelType() -> ModelType
    
    func fromPFObject(pf: PFObject) -> Type
    
    func withId(id: Int64) -> Type?
    
    func all() -> [Type]
    func select(filters: Filters?) -> [Type]
    
    func count(filters: Filters?) -> Int
    
    func insert(e: Type) -> Int64?
    
    func update(e: Type) -> Bool
    
    func delete(e: Type) -> Bool
    func delete(id: Int64) -> Bool
    
    func invalidate()
    
    func syncToRemote()
    func syncFromRemote()
    /*************************************
     END COPY PASTA FROM BASE ModelService
    **************************************/
    
    var transferId: Int64 { get }
    
    func transferType() -> Type
    
}