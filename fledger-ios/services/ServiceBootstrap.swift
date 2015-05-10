//
// Created by Robert Conrad on 5/10/15.
// Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation

class ServiceBootstrap {

    private static var _registered = false

    static func registered() -> Bool {
        register()
        return _registered
    }

    static func register() {

        Services.register(DatabaseService.self, DatabaseServiceImpl())

        Services.register(ItemService.self, ItemServiceImpl())
        Services.register(AccountService.self, AccountServiceImpl())
        Services.register(TypeService.self, TypeServiceImpl())
        Services.register(GroupService.self, GroupServiceImpl())
        Services.register(LocationService.self, LocationServiceImpl())

        _registered = true

    }

}
