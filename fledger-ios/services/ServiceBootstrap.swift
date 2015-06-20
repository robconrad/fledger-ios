//
// Created by Robert Conrad on 5/10/15.
// Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Parse

class ServiceBootstrap {

    private static var _registered = false

    // safe from multi-initialization
    static func registered() -> Bool {
        if (!_registered) {
            register()
        }
        return _registered
    }

    // allows forced reinitialization
    static func register() {

        // prerequisites to most services
        Services.register(DatabaseService.self, DatabaseServiceImpl(PFUser.currentUser()!.username!))
        Services.register(ParseService.self, ParseServiceImpl())

        // model services
        Services.register(ItemService.self, ItemServiceImpl())
        Services.register(AccountService.self, AccountServiceImpl())
        Services.register(TypeService.self, TypeServiceImpl())
        Services.register(GroupService.self, GroupServiceImpl())
        Services.register(LocationService.self, LocationServiceImpl())
        
        // secondary services
        Services.register(AggregateService.self, AggregateServiceImpl())

        _registered = true

    }

}

// sugared service locators
func DatabaseSvc()      -> DatabaseService      { return Services.get(DatabaseService.self)     }
func ParseSvc()         -> ParseService         { return Services.get(ParseService.self)        }
func ItemSvc()          -> ItemService          { return Services.get(ItemService.self)         }
func AccountSvc()       -> AccountService       { return Services.get(AccountService.self)      }
func TypeSvc()          -> TypeService          { return Services.get(TypeService.self)         }
func GroupSvc()         -> GroupService         { return Services.get(GroupService.self)        }
func LocationSvc()      -> LocationService      { return Services.get(LocationService.self)     }
func AggregateSvc()     -> AggregateService     { return Services.get(AggregateService.self)    }
