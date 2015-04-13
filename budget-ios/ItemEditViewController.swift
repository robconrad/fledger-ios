//
//  ItemViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemEditViewController: UIViewController {
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var account: UIButton!
    @IBOutlet weak var date: UIButton!
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var flow: UISwitch!
    @IBOutlet weak var comments: UITextView!
        
    var item: Item?
    
    var selectedAccountId: Int64?
    var selectedDate: NSDate?
    var selectedTypeId: Int64?
    
    var errors = false
    
    let defaultColor = UIColor.whiteColor()
    let errorColor = UIColor(red: 1, green: 184/255, blue: 184/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override func viewWillAppear(animated: Bool) {
        
        item = item?.copy(
            accountId: selectedAccountId,
            date: selectedDate,
            typeId: selectedTypeId)
        
        if let i = item {
            self.title = "Edit Item"
            account.setTitle(i.account().name, forState: .Normal)
            date.setTitle(i.date.datatypeValue, forState: .Normal)
            type.setTitle(i.type().name, forState: .Normal)
            amount.text = String(format: "%.2f", i.amount)
            flow.setOn(i.flow > 0, animated: true)
            comments.text = i.comments
        }
        else {
            self.title = "Add Item"
            if let accountId = selectedAccountId {
                account.setTitle(ModelServices.account.withId(accountId)!.name, forState: .Normal)
            }
            if let typeId = selectedTypeId {
                type.setTitle(ModelServices.type.withId(typeId)!.name, forState: .Normal)
            }
            if let myDate = selectedDate {
                date.setTitle(myDate.datatypeValue, forState: .Normal)
            }
            else {
                date.setTitle(NSDate().datatypeValue, forState: .Normal)
            }
        }
        
    }

    @IBAction func save(sender: AnyObject) {
        errors = false
        
        if item == nil {
            checkErrors(selectedAccountId == nil, item: accountLabel)
            checkErrors(selectedTypeId == nil, item: typeLabel)
            if selectedDate == nil {
                selectedDate = NSDate()
            }
        }
        
        let amountValue = (amount.text as NSString).doubleValue
        checkErrors(amountValue <= 0, item: amountLabel)
        
        let commentsValue = comments.text
        checkErrors(count(commentsValue) == 0, item: commentsLabel)
            
        if !errors {
            if let i = item {
                errors = !ModelServices.item.update(i.copy(
                    amount: amountValue,
                    flow: flow.on ? 1 : -1,
                    comments: commentsValue))
            }
            else {
                errors = ModelServices.item.insert(Item(
                    id: nil,
                    accountId: selectedAccountId!,
                    typeId: selectedTypeId!,
                    amount: amountValue,
                    flow: flow.on ? 1 : -1,
                    date: selectedDate!,
                    comments: commentsValue)) == nil
            }
            
            if !errors {
                if let nav = navigationController {
                    nav.popViewControllerAnimated(true)
                }
            }
        }
    }
    
    func checkErrors(errorCondition: Bool, item: UIView) {
        if errorCondition {
            item.backgroundColor = errorColor
        }
        else {
            item.backgroundColor = defaultColor
        }
        errors = errors || errorCondition
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectAccount" {
            if let dest = segue.destinationViewController as? ItemAccountEditViewController {
                dest.accountId = item?.accountId
            }
        }
        else if segue.identifier == "selectType" {
            if let dest = segue.destinationViewController as? ItemTypeEditViewController {
                dest.typeId = item?.typeId
            }
        }
        else if segue.identifier == "selectDate" {
            if let dest = segue.destinationViewController as? ItemDateEditViewController {
                dest.date = item?.date
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
}
