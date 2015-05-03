//
//  AccountServiceMock.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/3/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import fledger_ios


class AccountServiceMock<T: Account>: AccountService<Account> {
    
    required init(_ dbService: DatabaseService) {
        super.init(dbService)
    }
    
    override func update(e: Account) -> Bool {
        return true
    }
    
    override func insert(e: Account) -> Int64? {
        return 1
    }
    
}
