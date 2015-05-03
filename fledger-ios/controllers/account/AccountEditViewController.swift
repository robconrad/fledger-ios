//
//  ItemViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class AccountEditViewController: EditViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var active: UISwitch!
    
    var account: Account?
    
    var accountService = ModelServices.account
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let a = account {
            self.title = "Edit Account"
            name.text = a.name
            active.setOn(!a.inactive, animated: false)
        }
        else {
            self.title = "Add Account"
            active.setOn(true, animated: false)
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        checkErrors()
        
        if !errors {
            var id = account?.id
            
            if let a = account {
                errors = !accountService.update(a.copy(
                    name: name.text,
                    inactive: !active.on))
            }
            else {
                id = accountService.insert(Account(
                    id: nil,
                    name: name.text,
                    priority: 0,
                    inactive: !active.on))
                errors = id == nil
            }
            
            if !errors {
                editHandler(id)
            }
        }
    }
    
    func checkErrors() {
        errors = false
        checkErrors(name.text == "", item: nameLabel)
    }
    
}
