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
    @IBOutlet weak var loadActivity: UIActivityIndicatorView!
    @IBOutlet weak var syncActivity: UIActivityIndicatorView!
    
    private var dbService: DatabaseService!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dbService = DatabaseServiceImpl.main
    }
    
    convenience init(_ dbService: DatabaseService) {
        self.init(coder: NSCoder())
        self.dbService = dbService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadActivity.hidden = true
        loadActivity.startAnimating()
        
        syncActivity.hidden = true
        syncActivity.startAnimating()
        
        themeSwitch.setOn(AppStyling.get() == AppStyling.Mode.Light, animated: false)
    }
    
    @IBAction func themeSwitchChanged(sender: AnyObject) {
        
        AppStyling.set(themeSwitch.on ? AppStyling.Mode.Light : AppStyling.Mode.Dark)
        
        AppStyling.apply()
        
        let nav = tabBarController as! MainTabBarController
        nav.applyStyle()
    }
    
    @IBAction func loadFullDataset(sender: AnyObject) {
        loadActivity.hidden = false
        dbService.createDatabaseDestructive()
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            self.dbService.loadDefaultData("data")
            dispatch_async(dispatch_get_main_queue()) {
                self.loadActivity.hidden = true
            }
        }
    }
    
    @IBAction func syncFromParse(sender: AnyObject) {
        syncActivity.hidden = false
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            Services.get(ParseService.self).syncAllFromRemote()
            dispatch_async(dispatch_get_main_queue()) {
                self.syncActivity.hidden = true
            }
        }
    }
    
}