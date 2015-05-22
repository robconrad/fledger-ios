//
//  Services.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/3/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation


class Services {
    
    static private var registry: [String:AnyObject] = [:]
    
    // note that swift is a POS, we can't constrain the type of P here
    
    static func get<P>(proto: P.Type) -> P {
        if let service = registry["\(proto)"] as? P {
            return service
        }
        
        fatalError("\(proto) is not a registered service")
    }
    
    static func register<P>(proto: P.Type, _ service: AnyObject) {
        if service as? P == nil {
            fatalError("\(service) does not conform to \(proto)")
        }
        if service as? Service == nil {
            fatalError("\(service) does not conform to Service")
        }
        
        registry["\(proto)"] = service
    }
    
}