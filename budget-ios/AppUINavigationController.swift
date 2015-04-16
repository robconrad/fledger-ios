//
//  AppUINavigationController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/15/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class AppUINavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = AppColors.bgHeader
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: AppColors.text]
    }
    
}
