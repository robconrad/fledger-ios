//
//  AppUITableViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/14/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class AppUITableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUIViewController.applyColors(self)
    }
        
}
