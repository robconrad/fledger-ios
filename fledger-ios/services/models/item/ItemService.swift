//
//  LocationService.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/3/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import Parse


protocol ItemService: Service {
    
    /***************************************
     BEGIN COPY PASTA FROM BASE ModelService
     ***************************************/
    func modelType() -> ModelType
    
    func fromPFObject(pf: PFObject) -> Item
    
    func withId(id: Int64) -> Item?
    
    func all() -> [Item]
    func select(filters: Filters?) -> [Item]
    
    func count(filters: Filters?) -> Int
    
    func insert(e: Item) -> Int64?
    
    func update(e: Item) -> Bool
    
    func delete(e: Item) -> Bool
    func delete(id: Int64) -> Bool
    
    func invalidate()
    
    func syncToRemote()
    func syncFromRemote()
    /*************************************
     END COPY PASTA FROM BASE ModelService
    **************************************/
    
    func getTransferPair(first: Item) -> Item?
    
    func getSum(item: Item, filters: Filters) -> Double
    
    func getFiltersFromDefaults() -> ItemFilters
    
    func defaultCount() -> Int
    
}