//
//  ItemSearchViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class ItemSearchViewController: AppUIViewController {
    
    @IBOutlet weak var account: UIButton!
    @IBOutlet weak var startDate: UIButton!
    @IBOutlet weak var endDate: UIButton!
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var group: UIButton!
    
    var itemFilters: ItemFilters?
    
    override func viewWillAppear(animated: Bool) {
        
        if let accountId = itemFilters!.accountId {
            account.setTitle(ModelServices.account.withId(accountId)?.name ?? "?", forState: .Normal)
        }
        if let date = itemFilters!.startDate {
            startDate.setTitle(date.uiValue, forState: .Normal)
        }
        if let date = itemFilters!.endDate {
            endDate.setTitle(date.uiValue, forState: .Normal)
        }
        if let typeId = itemFilters!.typeId {
            type.setTitle(ModelServices.type.withId(typeId)?.name ?? "?", forState: .Normal)
        }
        if let groupId = itemFilters!.groupId {
            group.setTitle(ModelServices.group.withId(groupId)?.name ?? "?", forState: .Normal)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        itemFilters!.save()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectAccount" {
            if let dest = segue.destinationViewController as? AccountSelectionViewController {
                dest.accountId = itemFilters?.accountId
                dest.selectHandler = { accountId in
                    self.itemFilters!.accountId = accountId
                }
            }
        }
        else if segue.identifier == "selectType" {
            if let dest = segue.destinationViewController as? TypeSelectionViewController {
                dest.typeId = itemFilters?.typeId
                dest.selectHandler = { typeId in
                    self.itemFilters!.typeId = typeId
                }
            }
        }
        else if segue.identifier == "selectGroup" {
            if let dest = segue.destinationViewController as? GroupSelectionViewController {
                dest.groupId = itemFilters?.groupId
                dest.selectHandler = { groupId in
                    self.itemFilters!.groupId = groupId
                }
            }
        }
        else if segue.identifier == "selectStartDate" {
            if let dest = segue.destinationViewController as? DateSelectionViewController {
                dest.date = itemFilters?.startDate
                dest.selectHandler = { date in
                    self.itemFilters!.startDate = date
                }
            }
        }
        else if segue.identifier == "selectEndDate" {
            if let dest = segue.destinationViewController as? DateSelectionViewController {
                dest.date = itemFilters?.endDate
                dest.selectHandler = { date in
                    self.itemFilters!.endDate = date
                }
            }
        }
    }
    
    @IBAction func save(sender: AnyObject) {
        
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
        }
        
    }
    
    @IBAction func clear(sender: AnyObject) {
        
        itemFilters!.clear()
        
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
        }
        
    }
    
}
