//
//  DatabaseService.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class DatabaseService: NSObject {

    class var main: DatabaseService {
        struct Singleton {
            static let instance = DatabaseService()
        }
        return Singleton.instance
    }
    
}
