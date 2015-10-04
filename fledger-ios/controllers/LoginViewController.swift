//
//  LoginViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 6/20/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import UIKit
import FledgerCommon


class LoginViewController: AppUIViewController {
    
    lazy var helper: LoginViewHelper = {
        return LoginViewHelper(self, self)
    }()

    @IBOutlet weak var email: AppUITextField!
    @IBOutlet weak var emailLabel: AppUILabel!
    @IBOutlet weak var password: AppUITextField!
    @IBOutlet weak var passwordLabel: AppUILabel!
    
    override func viewDidLoad() {
        helper.loginFromCache()
        super.viewDidLoad()
    }
    
    @IBAction func login(sender: AnyObject) {
        helper.login()
    }
    
    @IBAction func signup(sender: AnyObject) {
        helper.signup()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension LoginViewController: LoginViewHelperDataSource {
    
    func getEmail() -> String {
        return email.text!
    }
    
    func getPassword() -> String {
        return password.text!
    }
    
}

extension LoginViewController: LoginViewHelperDelegate {
    
    func notifyEmailValidity(valid: Bool) {
        emailLabel.textColor = valid ? AppColors.text() : AppColors.textError()
    }
    
    func notifyPasswordValidity(valid: Bool) {
        passwordLabel.textColor = valid ? AppColors.text() : AppColors.textError()
    }
    
    func notifyLoginResult(valid: Bool) {
        notifyEmailValidity(valid)
        notifyPasswordValidity(valid)
        if valid {
            let controller = storyboard?.instantiateViewControllerWithIdentifier("mainTabBarController") as! MainTabBarController
            UIApplication.sharedApplication().delegate!.window!!.rootViewController = controller
        }
    }
    
}