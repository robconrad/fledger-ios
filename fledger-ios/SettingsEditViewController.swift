//
//  SettingsEditViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/19/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import UIKit


class SettingsEditViewController: AppUIViewController {
    
    @IBOutlet weak var themeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeSwitch.setOn(AppStyling.get() == AppStyling.Mode.Light, animated: false)
    }
    
    @IBAction func themeSwitchChanged(sender: AnyObject) {
        
        AppStyling.set(themeSwitch.on ? AppStyling.Mode.Light : AppStyling.Mode.Dark)
        
        AppStyling.apply()
        
        let nav = tabBarController as! MainTabBarController
        nav.applyStyle()
    }
    
}
