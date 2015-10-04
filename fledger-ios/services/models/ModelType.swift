//
//  Models.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/13/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation


enum ModelType: String, Printable {
    
    case Group = "group"
    case Typ = "type"
    case Account = "account"
    case Location = "location"
    case Item = "item"
    
    var description: String {
        return rawValue
    }
    
}