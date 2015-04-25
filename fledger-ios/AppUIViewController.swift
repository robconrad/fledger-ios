//
//  AppUIViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/14/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class AppUIViewController: UIViewController, CanStyle {
    
    static func applyStyle(view: UIViewController) {
        
        view.view.backgroundColor = AppColors.bgMain()
    }
    
    func applyStyle() {
        AppUIViewController.applyStyle(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyStyle()
    }
    
}
