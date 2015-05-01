//
//  AppStyling.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/25/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation


class AppStyling {
    
    enum Mode: Int {
        case Dark = 0
        case Light = 1
    }
    
    private static let modeKey = "appStylingMode"
    
    static func set(mode: Mode) {
        NSUserDefaults.standardUserDefaults().setInteger(mode.rawValue, forKey: modeKey)
    }
    
    static func get() -> Mode {
        return Mode(rawValue: NSUserDefaults.standardUserDefaults().integerForKey(modeKey))!
    }
    
    static func apply() {
        switch get() {
        case .Light: UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        case .Dark: UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        }
    }
    
}