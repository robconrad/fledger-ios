//
//  Accounts.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

class ModelServices {
    
    static private let service = DatabaseServiceImpl.main
    
    static let account = AccountService<Account>(service)
    static let type = TypeService<Type>(service)
    static let group = GroupService<Group>(service)
    static let location = LocationService<Location>(service)
    static let item = ItemService<Item>(service)
    
}


