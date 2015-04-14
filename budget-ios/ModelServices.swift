//
//  Accounts.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

class ModelServices {
    
    static let account = AccountService<Account>()
    static let type = TypeService<Type>()
    static let group = GroupService<Group>()
    static let item = ItemService<Item>()
    
}


