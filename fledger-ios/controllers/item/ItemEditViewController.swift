//
//  ItemViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit
import CoreLocation


class ItemEditViewController: EditViewController {
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var locationLabel: AppUILabel!
    
    @IBOutlet weak var account: UIButton!
    @IBOutlet weak var date: UIButton!
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var amount: AppUITextField!
    @IBOutlet weak var flow: UISwitch!
    @IBOutlet weak var comments: AppUITextField!
    @IBOutlet weak var location: UIButton!
    
    @IBOutlet weak var toolbar: AppUIToolbar!
    
    var item: Item?
    
    var selectedAccountId: Int64?
    var selectedDate: NSDate?
    var selectedTypeId: Int64?
    var selectedLocationId: Int64?
    
    var deletedLocation: Bool = false
    
    var selectingModel: ModelType?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        item = item?.copy(
            accountId: selectedAccountId,
            date: selectedDate,
            typeId: selectedTypeId,
            locationId: selectedLocationId)
        
        item = item?.clear(
            locationId: deletedLocation)
        deletedLocation = false
        
        if let i = item {
            self.title = "Edit Item"
            account.setTitle(i.account().name, forState: .Normal)
            date.setTitle(i.date.uiValue, forState: .Normal)
            type.setTitle(i.type().name, forState: .Normal)
            location.setTitle(i.location()?.title() ?? "[select location]", forState: .Normal)
            amount.text = String(format: "%.2f", abs(i.amount))
            flow.setOn(i.amount > 0, animated: true)
            comments.text = i.comments
        }
        else {
            self.title = "Add Item"
            if let accountId = selectedAccountId {
                account.setTitle(Services.get(AccountService.self).withId(accountId)!.name, forState: .Normal)
            }
            
            if let typeId = selectedTypeId {
                type.setTitle(Services.get(TypeService.self).withId(typeId)!.name, forState: .Normal)
            }
            
            if let locationId = selectedLocationId {
                location.setTitle(Services.get(LocationService.self).withId(locationId)?.title() ?? "[none]", forState: .Normal)
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
            var id = item?.id
            
            if let i = item {
                errors = !Services.get(ItemService.self).update(i.copy(
                    amount: amountValue(includeFlow: true),
                    comments: comments.text))
            }
            else {
                id = Services.get(ItemService.self).insert(Item(
                    id: nil,
                    accountId: selectedAccountId!,
                    typeId: selectedTypeId!,
                    locationId: selectedLocationId,
                    amount: amountValue(includeFlow: true),
                    date: selectedDate!,
                    comments: comments.text))
                errors = id == nil
            }
            
            if !errors {
                Services.get(LocationService.self).cleanup()
                editHandler(id)
            }
        }
    }
    
    @IBAction func remove(sender: AnyObject) {
        errors = false
        
        if let i = item {
            errors = !Services.get(ItemService.self).delete(i)
        }
        
        if !errors {
            editHandler(nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectAccount" {
            if let dest = segue.destinationViewController as? AccountSelectionViewController {
                selectingModel = ModelType.Account
                dest.accountId = selectedAccountId ?? item?.accountId
                dest.selectHandler = { accountId in
                    self.selectedAccountId = accountId
                }
            }
        }
        else if segue.identifier == "selectType" {
            if let dest = segue.destinationViewController as? TypeSelectionViewController {
                selectingModel = ModelType.Typ
                dest.typeId = selectedTypeId ?? item?.typeId
                dest.selectHandler = { typeId in
                    if typeId == Services.get(TypeService.self).transferId {
                        if let transferController = self.storyboard?.instantiateViewControllerWithIdentifier("transferEditViewController") as? TransferEditViewController {
                            transferController.selectedDate = self.selectedDate
                            if self.flow.on {
                                transferController.selectedIntoAccountId = self.selectedAccountId
                            }
                            else {
                                transferController.selectedFromAccountId = self.selectedAccountId
                            }
                            self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] = transferController
                        }
                    }
                    else {
                        self.selectedTypeId = typeId
                    }
                }
            }
        }
        else if segue.identifier == "selectDate" {
            if let dest = segue.destinationViewController as? DateSelectionViewController {
                dest.date = selectedDate ?? item?.date
                dest.selectHandler = { date in
                    self.selectedDate = date
                }
            }
        }
        else if segue.identifier == "selectLocation" {
            if let dest = segue.destinationViewController as? LocationSelectionViewController {
                dest.locationId = selectedLocationId ?? item?.locationId
                dest.selectHandler = { locationId in
                    self.selectedLocationId = locationId
                }
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
        checkLocationError()
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
    
    func checkLocationError() {
        // nada mucho
    }
    
}