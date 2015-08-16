//
//  ItemViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit
import FledgerCommon


class GroupEditViewController: EditViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var name: UITextField!
    
    var group: Group?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let g = group {
            self.title = "Edit Group"
            name.text = g.name
        }
        else {
            self.title = "Add Group"
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        checkErrors()
        
        if !errors {
            var id = group?.id
            
            if let g = group {
                errors = !GroupSvc().update(g.copy(
                    name: name.text))
            }
            else {
                id = GroupSvc().insert(Group(
                    id: nil,
                    name: name.text))
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
