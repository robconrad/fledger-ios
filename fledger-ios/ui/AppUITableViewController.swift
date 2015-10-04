//
//  AppUITableViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/14/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class AppUITableViewController: UITableViewController, CanStyle {
    
    func applyStyle() {
        AppUIViewController.applyStyle(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyStyle()
    }
        
}
