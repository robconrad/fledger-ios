//
//  ItemViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

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
            if let g = group {
                errors = !ModelServices.group.update(g.copy(
                    name: name.text))
            }
            else {
                errors = ModelServices.group.insert(Group(
                    id: nil,
                    name: name.text)) == nil
            }
            
            if !errors {
                segueBack()
            }
        }
    }
    
    func checkErrors() {
        errors = false
        checkErrors(name.text == "", item: nameLabel)
    }
    
}
