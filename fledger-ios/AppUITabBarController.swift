//
//  AppUITabBarController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/15/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class AppUITabBarController: UITabBarController, CanStyle {
    
    func applyStyle() {
        tabBar.barTintColor = AppColors.bgHeader()
        tabBar.tintColor = AppColors.text()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyStyle()
    }
    
}
