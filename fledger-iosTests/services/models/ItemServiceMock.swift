//
//  ItemServiceMock.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/22/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Parse


class ItemServiceMock: ItemService {
    
    var withIdResult: Item? = nil
    var selectResult: [Item] = []
    var countResult = 0
    var updateResult = true
    var insertResult: Int64? = 1
    var deleteResult = true
    var fromPFObjectResult: (PFObject) -> Item = { _ in
        // fucking swift.
        return fatalError(__FUNCTION__ + " must be implemented") as! Item
    }
    var getTransferPairResult: Item? = nil
    var getSumResult = 0.0
    
    func modelType() -> ModelType {
        return .Item
    }
    
    func fromPFObject(pf: PFObject) -> Item {
        return fromPFObjectResult(pf)
    }
    
    func withId(id: Int64) -> Item? {
        return withIdResult
    }
    
    func all() -> [Item] {
        return selectResult
    }
    
    func select(filters: Filters?) -> [Item] {
        return selectResult
    }
    
    func count(filters: Filters?) -> Int {
        return countResult
    }
    
    func update(e: Item) -> Bool {
        return updateResult
    }
    
    func insert(e: Item) -> Int64? {
        return insertResult
    }
    
    func delete(e: Item) -> Bool {
        return deleteResult
    }
    
    func delete(id: Int64) -> Bool {
        return deleteResult
    }
    
    func invalidate() {
        
    }
    
    func syncToRemote() {
        
    }
    
    func syncFromRemote() {
        
    }
    
    func getTransferPair(first: Item) -> Item? {
        return getTransferPairResult
    }
    
    func getSum(item: Item, filters: Filters) -> Double {
        return getSumResult
    }
    
}