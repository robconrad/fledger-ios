//
//  ItemViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class TypeEditViewController: EditViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var group: UIButton!
    
    var type: Type?
    
    var selectingGroup = false
    var selectedGroupId: Int64?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let t = type {
            self.title = "Edit Type"
            name.text = t.name
            group.setTitle(t.group().name, forState: .Normal)
        }
        else {
            self.title = "Add Type"
            if let groupId = selectedGroupId {
                group.setTitle(ModelServices.group.withId(groupId)!.name, forState: .Normal)
            }
        }
        
        if selectingGroup {
            checkGroupError()
            selectingGroup = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectGroup" {
            if let dest = segue.destinationViewController as? ItemGroupEditViewController {
                selectingGroup = true
                dest.groupId = type?.groupId
            }
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        checkErrors()
        
        if !errors {
            if let t = type {
                errors = !ModelServices.type.update(t.copy(
                    name: name.text))
            }
            else {
                errors = ModelServices.type.insert(Type(
                    id: nil,
                    groupId: selectedGroupId!,
                    name: name.text)) == nil
            }
            
            if !errors {
                segueBack()
            }
        }
    }
    
    func checkErrors() {
        errors = false
        checkGroupError()
        checkNameError()
    }
    
    func checkNameError() {
        checkErrors(name.text == "", item: nameLabel)
    }
    
    func checkGroupError() {
        if type == nil {
            checkErrors(selectedGroupId == nil, item: groupLabel)
        }
    }
    
}
