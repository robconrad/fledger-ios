//
//  Model.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import SQLite
import Parse


protocol Model: Equatable, PFObjectConvertible {
    
    var id: Int64? { get }
    var modelType: ModelType { get }
    var pf: PFObject? { get }
    
    func toSetters() -> [Setter]
    
    func parse() -> ParseModel?
    
}
