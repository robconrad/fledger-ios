//
//  AppDelegate.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Initialize Parse.
        Parse.setApplicationId("fjcMqJqBTJsHRsrDkuKk7wGuAMMTu1d4820IdBQg", clientKey: "hyiXQhwKd2aQvusxJuRliyxrKEhRx6Xx9gTndNaV")
        
        if PFUser.currentUser() == nil {
            var user = PFUser()
            user.username = "foo" // + String(arc4random())
            user.password = "bar"
            user.email = user.username! + "@bar.baz"
            
            if PFUser.logInWithUsername(user.username!, password: user.password!) == nil {
                if !user.signUp() {
                    fatalError("parse signup failed")
                }
            }
        }
        
        println("register services \(ServiceBootstrap.registered())")

        if true || !NSUserDefaults.standardUserDefaults().boolForKey("created") {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "created")
            DatabaseSvc().createDatabaseDestructive()
            //DatabaseSvc().loadDefaultData()
        }
        
        AppStyling.apply()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        ParseSvc().syncAllFromRemoteInBackground()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

