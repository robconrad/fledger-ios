//
//  SelectIdHandler.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/2/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation


typealias SelectIdHandler = (Int64) -> Void
typealias SelectDateHandler = (NSDate) -> Void

typealias EditIdHandler = (Int64?) -> Void