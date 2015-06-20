//
//  LoginViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 6/20/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import UIKit
import Parse


class LoginViewController: AppUIViewController {

    @IBOutlet weak var email: AppUITextField!
    @IBOutlet weak var emailLabel: AppUILabel!
    @IBOutlet weak var password: AppUITextField!
    @IBOutlet weak var passwordLabel: AppUILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func login(sender: AnyObject) {
        if !validateFields() {
            return
        }
        
        if PFUser.logInWithUsername(email.text, password: password.text) != nil {
            handleSuccess()
        }
        else {
            password.textColor = AppColors.textError()
        }
    }
    
    @IBAction func signup(sender: AnyObject) {
        if !validateFields() {
            return
        }
        
        let user = PFUser()
        user.username = email.text
        user.password = password.text
        user.email = email.text
        
        if user.signUp() {
            handleSuccess()
        }
        else {
            email.textColor = AppColors.textError()
        }
    }
    
    private func handleSuccess() {
        // services can't be registered until a PFUser is logged in
        println("register services \(ServiceBootstrap.registered())")
        
        let controller = storyboard?.instantiateViewControllerWithIdentifier("mainTabBarController") as! MainTabBarController
        UIApplication.sharedApplication().delegate!.window!!.rootViewController = controller
    }
    
    private func validateFields() -> Bool {
        var valid = true
        
        emailLabel.textColor = AppColors.text()
        if count(email.text) < 5 {
            emailLabel.textColor = AppColors.textError()
            valid = false
        }
        
        passwordLabel.textColor = AppColors.text()
        if count(password.text) < 3 {
            passwordLabel.textColor = AppColors.textError()
            valid = false
        }
        
        return valid
    }
    
}