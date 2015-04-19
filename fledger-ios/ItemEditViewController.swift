//
//  ItemViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit



class ItemEditViewController: EditViewController {
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var account: UIButton!
    @IBOutlet weak var date: UIButton!
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var amount: AppUITextField!
    @IBOutlet weak var flow: UISwitch!
    @IBOutlet weak var comments: AppUITextField!
    
    @IBOutlet weak var toolbar: AppUIToolbar!
    
    var item: Item?
    
    var selectedAccountId: Int64?
    var selectedDate: NSDate?
    var selectedTypeId: Int64?
    
    var selectingModel: ModelType?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        item = item?.copy(
            accountId: selectedAccountId,
            date: selectedDate,
            typeId: selectedTypeId)
        
        if let i = item {
            self.title = "Edit Item"
            account.setTitle(i.account().name, forState: .Normal)
            date.setTitle(i.date.uiValue, forState: .Normal)
            type.setTitle(i.type().name, forState: .Normal)
            amount.text = String(format: "%.2f", abs(i.amount))
            flow.setOn(i.amount > 0, animated: true)
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
                date.setTitle(myDate.uiValue, forState: .Normal)
            }
            else {
                date.setTitle(NSDate().uiValue, forState: .Normal)
            }
            toolbar.hidden = true
        }
        
        if let model = selectingModel {
            switch model {
            case ModelType.Account: checkAccountError()
            case ModelType.Typ: checkTypeError()
            default: break
            }
            selectingModel = nil
        }
    }
    
    @IBAction func amountValueChanged(sender: AnyObject) {
        checkAmountError()
    }
    
    @IBAction func commentsValueChanged(sender: AnyObject) {
        checkCommentsError()
    }
    
    @IBAction func save(sender: AnyObject) {
        checkErrors()
        
        if !errors {
            if let i = item {
                errors = !ModelServices.item.update(i.copy(
                    amount: amountValue(includeFlow: true),
                    comments: comments.text))
            }
            else {
                errors = ModelServices.item.insert(Item(
                    id: nil,
                    accountId: selectedAccountId!,
                    typeId: selectedTypeId!,
                    amount: amountValue(includeFlow: true),
                    date: selectedDate!,
                    comments: comments.text)) == nil
            }
            
            if !errors {
                segueBack()
            }
        }
    }
    
    @IBAction func remove(sender: AnyObject) {
        errors = false
        
        if let i = item {
            errors = !ModelServices.item.delete(i)
        }
        
        if !errors {
            segueBack()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectAccount" {
            if let dest = segue.destinationViewController as? ItemAccountEditViewController {
                selectingModel = ModelType.Account
                dest.accountId = item?.accountId
            }
        }
        else if segue.identifier == "selectType" {
            if let dest = segue.destinationViewController as? ItemTypeEditViewController {
                selectingModel = ModelType.Typ
                dest.typeId = item?.typeId
            }
        }
        else if segue.identifier == "selectDate" {
            if let dest = segue.destinationViewController as? ItemDateEditViewController {
                dest.date = item?.date
            }
        }
    }
    
    func amountValue(includeFlow: Bool = false) -> Double {
        var a = (amount.text as NSString).doubleValue
        if includeFlow && !flow.on {
            a = -a
        }
        return a
    }
    
    func checkErrors() {
        errors = false
        
        if item == nil {
            if selectedDate == nil {
                selectedDate = NSDate()
            }
        }
        
        checkAccountError()
        checkTypeError()
        checkAmountError()
        checkCommentsError()
    }
    
    func checkAccountError() {
        if item == nil {
            checkErrors(selectedAccountId == nil, item: accountLabel)
        }
    }
    
    func checkTypeError() {
        if item == nil {
            checkErrors(selectedTypeId == nil, item: typeLabel)
        }
    }
    
    func checkAmountError() {
        checkErrors(amountValue() <= 0, item: amountLabel)
    }
    
    func checkCommentsError() {
        checkErrors(count(comments.text) == 0, item: commentsLabel)
    }
    
}