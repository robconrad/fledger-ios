//
//  ItemViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class TransferEditViewController: EditViewController {
    
    @IBOutlet weak var fromAccountLabel: UILabel!
    @IBOutlet weak var intoAccountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var fromAccount: UIButton!
    @IBOutlet weak var intoAccount: UIButton!
    @IBOutlet weak var date: UIButton!
    @IBOutlet weak var amount: AppUITextField!
    @IBOutlet weak var comments: AppUITextField!
    
    @IBOutlet weak var toolbar: AppUIToolbar!
    
    var fromItem: Item?
    var intoItem: Item?
    
    var selectedFromAccountId: Int64?
    var selectedIntoAccountId: Int64?
    var selectedDate: NSDate?
    
    var selectingFromAccount = false
    var selectingIntoAccount = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        type.setTitle(ModelServices.type.transferType().name, forState: .Normal)
        
        fromItem = fromItem?.copy(
            accountId: selectedFromAccountId,
            date: selectedDate)
        
        intoItem = intoItem?.copy(
            accountId: selectedIntoAccountId,
            date: selectedDate)
        
        if fromItem != nil && intoItem != nil {
            self.title = "Edit Transfer"
            type.enabled = false
            fromAccount.setTitle(fromItem!.account().name, forState: .Normal)
            intoAccount.setTitle(intoItem!.account().name, forState: .Normal)
            date.setTitle(fromItem!.date.uiValue, forState: .Normal)
            amount.text = String(format: "%.2f", abs(fromItem!.amount))
            comments.text = fromItem!.comments
        }
        else {
            self.title = "Add Transfer"
            if let accountId = selectedFromAccountId {
                fromAccount.setTitle(ModelServices.account.withId(accountId)!.name, forState: .Normal)
            }
            if let accountId = selectedIntoAccountId {
                intoAccount.setTitle(ModelServices.account.withId(accountId)!.name, forState: .Normal)
            }
            if let myDate = selectedDate {
                date.setTitle(myDate.uiValue, forState: .Normal)
            }
            else {
                date.setTitle(NSDate().uiValue, forState: .Normal)
            }
            if comments.text == "" {
                comments.text = "transfer"
            }
            toolbar.hidden = true
        }
        
        if selectingFromAccount {
            checkFromAccountError()
            selectingFromAccount = false
        }
        if selectingIntoAccount {
            checkIntoAccountError()
            selectingIntoAccount = false
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
            if fromItem != nil && intoItem != nil {
                // TODO - do this in a transaction
                errors = errors || !ModelServices.item.update(fromItem!.copy(
                    amount: -amountValue(),
                    comments: comments.text))
                errors = errors || !ModelServices.item.update(intoItem!.copy(
                    amount: amountValue(),
                    comments: comments.text))
            }
            else {
                // TODO - do this in a transaction
                errors = errors || ModelServices.item.insert(Item(
                    id: nil,
                    accountId: selectedFromAccountId!,
                    typeId: ModelServices.type.transferId,
                    locationId: nil,
                    amount: -amountValue(),
                    date: selectedDate!,
                    comments: comments.text)) == nil
                errors = errors || ModelServices.item.insert(Item(
                    id: nil,
                    accountId: selectedIntoAccountId!,
                    typeId: ModelServices.type.transferId,
                    locationId: nil,
                    amount: amountValue(),
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
        
        // TODO - do this in a transaction
        if let i = fromItem {
            errors = errors || !ModelServices.item.delete(i)
        }
        if let i = intoItem {
            errors = errors || !ModelServices.item.delete(i)
        }
        
        if !errors {
            segueBack()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectFromAccount" {
            if let dest = segue.destinationViewController as? AccountSelectionViewController {
                selectingFromAccount = true
                dest.accountId = fromItem?.accountId
                dest.selectHandler = { accountId in
                    self.selectedFromAccountId = accountId
                }
            }
        }
        else if segue.identifier == "selectIntoAccount" {
            if let dest = segue.destinationViewController as? AccountSelectionViewController {
                selectingIntoAccount = true
                dest.accountId = intoItem?.accountId
                dest.selectHandler = { accountId in
                    self.selectedIntoAccountId = accountId
                }
            }
        }
        else if segue.identifier == "selectDate" {
            if let dest = segue.destinationViewController as? DateSelectionViewController {
                dest.date = fromItem?.date
                dest.selectHandler = { date in
                    self.selectedDate = date
                }
            }
        }
    }
    
    func amountValue() -> Double {
        return (amount.text as NSString).doubleValue
    }
    
    func checkErrors() {
        errors = false
        
        if fromItem == nil {
            if selectedDate == nil {
                selectedDate = NSDate()
            }
        }
        
        checkFromAccountError()
        checkIntoAccountError()
        checkAmountError()
        checkCommentsError()
    }
    
    func checkFromAccountError() {
        if fromItem == nil {
            checkErrors(selectedFromAccountId == nil, item: fromAccountLabel)
            checkErrors(selectedFromAccountId == selectedIntoAccountId, item: fromAccountLabel)
        }
    }
    
    func checkIntoAccountError() {
        if intoItem == nil {
            checkErrors(selectedIntoAccountId == nil, item: intoAccountLabel)
            checkErrors(selectedIntoAccountId == selectedFromAccountId, item: intoAccountLabel)
        }
    }
    
    func checkAmountError() {
        checkErrors(amountValue() <= 0, item: amountLabel)
    }
    
    func checkCommentsError() {
        checkErrors(count(comments.text) == 0, item: commentsLabel)
    }
    
}