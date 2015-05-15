//
//  CanCreatePFObject.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/14/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import Parse


protocol PFObjectConvertible {
    
    func toPFObject() -> PFObject?
    
}