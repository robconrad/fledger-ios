//
//  Accounts.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

let accountManager = AccountManager()
let typeManager = TypeManager()

class AccountManager<T: Account where T: Model>: Manager<T> {
    
    override internal func __all() -> [T] {
        return model.getAccounts() as! [T]
    }
    
}

class TypeManager<T: Type where T: Model>: Manager<T> {
    
    override internal func __all() -> [T] {
        return model.getTypes() as! [T]
    }
    
}
