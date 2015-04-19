//
//  AppUIViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/14/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class AppUIViewController: UIViewController {
    
    static func applyColors(view: UIViewController) {
        
        view.view.backgroundColor = AppColors.bgMain
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUIViewController.applyColors(self)
    }
    
}
