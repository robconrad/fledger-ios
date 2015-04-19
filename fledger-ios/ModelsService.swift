//
//  ModelService.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation


class ModelsService: NSObject {
    
    class var main: ModelsService {
        struct Singleton {
            static let instance = ModelsService()
        }
        return Singleton.instance
    }
    
    let db = DatabaseService.main
    
    func initializeDataStorage() {
        db.createDatabaseDestructive()
    }
    
    func getAccounts() -> [Account] {
        return db.getAccounts()
    }
    
    func getTypes() -> [Type] {
        return db.getTypes()
    }
    
    func getItems(
        offset: Int = 0,
        count: Int = 30,
        itemFilters: ItemFilters? = nil
        ) -> [Item] {
        return db.getItems(offset: offset, count: count, itemFilters: itemFilters)
    }
    
    func getItemCount() -> Int {
        return db.getItemCount()
    }
    
    func update(item: Item) -> Bool {
        return db.update(item)
    }
    
    func insert(item: Item) -> Int64? {
        return db.insert(item)
    }
    
}