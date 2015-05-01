//
//  Models.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/13/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation


enum ModelType {
    
    case Group
    case Typ
    case Account
    case Location
    case Item
    
    var string: String {
        switch self {
        case Group: return "group"
        case Typ: return "type"
        case Account: return "account"
        case Location: return "location"
        case Item: return "item"
        }
    }
    
}