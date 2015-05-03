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
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    private var dbService: DatabaseService!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dbService = DatabaseService.main
    }
    
    convenience init(_ dbService: DatabaseService) {
        self.init(coder: NSCoder())
        self.dbService = dbService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activity.hidden = true
        activity.startAnimating()
        
        themeSwitch.setOn(AppStyling.get() == AppStyling.Mode.Light, animated: false)
    }
    
    @IBAction func themeSwitchChanged(sender: AnyObject) {
        
        AppStyling.set(themeSwitch.on ? AppStyling.Mode.Light : AppStyling.Mode.Dark)
        
        AppStyling.apply()
        
        let nav = tabBarController as! MainTabBarController
        nav.applyStyle()
    }
    
    @IBAction func loadFullDataset(sender: AnyObject) {
        activity.hidden = false
        dbService.createDatabaseDestructive()
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.dbService.loadDefaultData(file: "data")
            dispatch_async(dispatch_get_main_queue()) {
                self.activity.hidden = true
            }
        }
    }
    
}