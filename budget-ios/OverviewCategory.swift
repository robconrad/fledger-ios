//
//  OverviewCategory.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/18/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation


enum OverviewCategory: String {
    
    case All = "All"
    case Account = "Account"
    case Typ = "Type"
    case Group = "Group"
    
    static let values = [All, Account, Typ, Group]
    
}