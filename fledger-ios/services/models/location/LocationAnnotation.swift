//
//  LocationAnnotation.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/26/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation
import MapKit


class LocationAnnotation: MKPointAnnotation {
    
    let location: Location
    
    required init(location: Location) {
        self.location = location
        
        super.init()
        
        coordinate = location.coordinate
        title = location.title()
        subtitle = location.title() == location.address ? nil : location.address
    }
    
}