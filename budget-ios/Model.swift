//
//  Model.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import SQLite


protocol Model {
    
    var id: Int64? { get }
    
    func toSetters() -> [Setter]
    
}
