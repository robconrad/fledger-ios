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
    var updatedLocation: Location?
    
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
        
        if let i = item {
            let loc = i.location()
            self.title = "Edit Item"
            account.setTitle(i.account().name, forState: .Normal)
            date.setTitle(i.date.uiValue, forState: .Normal)
            type.setTitle(i.type().name, forState: .Normal)
            location.setTitle(updatedLocation?.title() ?? loc?.title() ?? "[select location]", forState: .Normal)
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
            
            if let loc = updatedLocation {
                location.setTitle(loc.title() ?? "[none]", forState: .Normal)
            }
            else if let locationId = selectedLocationId {
                location.setTitle(ModelServices.location.withId(locationId)?.title() ?? "[none]", forState: .Normal)
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
                    locationId: selectedLocationId,
                    amount: amountValue(includeFlow: true),
                    date: selectedDate!,
                    comments: comments.text)) == nil
            }
            
            if !errors {
                ModelServices.location.cleanup()
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
                dest.accountId = selectedAccountId ?? item?.accountId
            }
        }
        else if segue.identifier == "selectType" {
            if let dest = segue.destinationViewController as? ItemTypeEditViewController {
                selectingModel = ModelType.Typ
                dest.typeId = selectedTypeId ?? item?.typeId
            }
        }
        else if segue.identifier == "selectDate" {
            if let dest = segue.destinationViewController as? ItemDateEditViewController {
                dest.date = selectedDate ?? item?.date
            }
        }
        else if segue.identifier == "selectLocation" {
            if let dest = segue.destinationViewController as? ItemLocationEditViewController {
                dest.model.setLocationId(selectedLocationId ?? item?.locationId)
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
        // don't attempt location updates until all other errors are cleared
        if errors {
            return
        }
        
        if let location = updatedLocation {
            if let id = location.id {
                // this location is used in multiple items, don't update make new instead
                if ModelServices.location.itemCount(id) > 1 {
                    selectedLocationId = ModelServices.location.insert(location)
                    checkErrors(selectedLocationId == nil, item: locationLabel)
                }
                // this location is only used in one item, update instead of new
                else {
                    let result = ModelServices.location.update(location)
                    selectedLocationId = id
                    checkErrors(!result, item: locationLabel)
                }
            }
            else {
                selectedLocationId = ModelServices.location.insert(location)
                checkErrors(selectedLocationId == nil, item: locationLabel)
            }
            item = item?.copy(locationId: selectedLocationId)
        }
    }
    
}