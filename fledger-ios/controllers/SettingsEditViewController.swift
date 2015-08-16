//
//  SettingsEditViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/19/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import UIKit
import FledgerCommon


class SettingsEditViewController: AppUIViewController {
    
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var loadActivity: AppUIActivityIndicatorView!
    @IBOutlet weak var syncToParseButton: UIButton!
    @IBOutlet weak var syncToParseActivity: AppUIActivityIndicatorView!
    @IBOutlet weak var syncFromParseButton: UIButton!
    @IBOutlet weak var syncFromParseActivity: AppUIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadActivity.hidden = true
        loadActivity.startAnimating()
        
        syncToParseActivity.hidden = true
        syncToParseActivity.startAnimating()
        
        syncFromParseActivity.hidden = true
        syncFromParseActivity.startAnimating()
        
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
        DatabaseSvc().createDatabaseDestructive()
        execActivityAsync(loadActivity, loadButton, {
            return DatabaseSvc().loadDefaultData("data")
        })
    }
    
    @IBAction func syncToParse(sender: AnyObject) {
        execActivityAsync(syncToParseActivity, syncToParseButton, {
            return ParseSvc().syncAllToRemote()
        })
    }
    
    @IBAction func syncFromParse(sender: AnyObject) {
        execActivityAsync(syncFromParseActivity, syncFromParseButton, {
            return ParseSvc().syncAllFromRemote()
        })
    }
    
    @IBAction func logout(sender: AnyObject) {
        ParseSvc().logout()
        let controller = storyboard?.instantiateViewControllerWithIdentifier("loginViewController") as! LoginViewController
        UIApplication.sharedApplication().delegate!.window!!.rootViewController = controller
    }
    
    private func execActivityAsync(indicator: AppUIActivityIndicatorView, _ button: UIButton, _ activity: () -> ()) {
        button.enabled = false
        indicator.hidden = false
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            activity()
            dispatch_async(dispatch_get_main_queue()) {
                button.enabled = true
                indicator.hidden = true
            }
        }
    }
    
}