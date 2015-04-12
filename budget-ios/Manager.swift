//
//  Manager.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

class Manager<T: Model> {
    
    // return all managed models of the type
    internal var _allArray: [T]?
    internal var _allDict: [Int64: T]?
    
    func withId(id: Int64) -> T? {
        if let a = _allDict {
            return a[id]
        }
        else {
            all()
            return withId(id)
        }
    }
    
    func all() -> [T] {
        if _allArray == nil {
            _allArray = __all()
            _allDict = Dictionary<Int64, T>()
            for e in _allArray! {
                _allDict![e.id] = e
            }
        }
        return _allArray!
    }
    
    internal func __all() -> [T] {
        fatalError(__FUNCTION__ + " must be implemented")
    }
    
    func invalidate() {
        _allArray = nil
        _allDict = nil
    }
    
}
