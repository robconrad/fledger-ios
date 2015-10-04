//
//  ArrayExtension.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/25/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation

extension Array {
    func find(includedElement: Element -> Bool) -> Int? {
        for (idx, element) in self.enumerate() {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
}