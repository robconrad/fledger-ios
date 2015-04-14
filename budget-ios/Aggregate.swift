//
//  Aggregate.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/12/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation


class Aggregate {
    
    let model: ModelType?
    let id: Int64?
    let name: String
    let value: Double
    
    required init(model: ModelType?, id: Int64?, name: String, value: Double) {
        self.model = model
        self.id = id
        self.name = name
        self.value = value
    }
    
    func toString() -> String {
        let v = String(format: "%.2f", value)
        return "\(name) - \(v)"
    }
    
}