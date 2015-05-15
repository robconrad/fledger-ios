//
//  AccountServiceMock.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/3/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import fledger_ios
import Parse


class AccountServiceMock: AccountService {
    
    func modelType() -> ModelType {
        return .Account
    }
    
    func fromPFObject(pf: PFObject) -> Account {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
    func withId(id: Int64) -> Account? {
        return nil
    }
    
    func all() -> [Account] {
        return []
    }
    
    func select(filters: Filters?) -> [Account] {
        return []
    }
    
    func count(filters: Filters?) -> Int {
        return 1
    }
    
    func update(e: Account) -> Bool {
        return true
    }
    
    func insert(e: Account) -> Int64? {
        return 1
    }
    
    func delete(e: Account) -> Bool {
        return true
    }
    
    func delete(id: Int64) -> Bool {
        return true
    }
    
    func invalidate() {
        
    }
    
    func syncToRemote() {
        
    }
    
    func syncFromRemote() {
        
    }
    
}
