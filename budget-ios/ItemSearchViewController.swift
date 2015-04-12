//
//  ItemSearchViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class ItemSearchViewController: UIViewController {
    
    @IBOutlet weak var account: UIButton!
    @IBOutlet weak var startDate: UIButton!
    @IBOutlet weak var endDate: UIButton!
    @IBOutlet weak var type: UIButton!
    
    var itemFilters: ItemFilters?
    
    private var askingForStartDate = false
    private var askingForEndDate = false
    
    func setDate(date: NSDate) {
        if askingForStartDate {
            itemFilters!.startDate = date
        }
        if askingForEndDate {
            itemFilters!.endDate = date
        }
        askingForStartDate = false
        askingForEndDate = false
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let accountId = itemFilters!.accountId {
            account.setTitle(accountManager.withId(accountId)!.name, forState: .Normal)
        }
        if let date = itemFilters!.startDate {
            startDate.setTitle(date.datatypeValue, forState: .Normal)
        }
        if let date = itemFilters!.endDate {
            endDate.setTitle(date.datatypeValue, forState: .Normal)
        }
        if let typeId = itemFilters!.typeId {
            type.setTitle(typeManager.withId(typeId)!.name, forState: .Normal)
        }
        
        askingForStartDate = false
        askingForEndDate = false
        
    }
    
    @IBAction func save(sender: AnyObject) {
        
        itemFilters!.save()
        
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
        }
        
    }
    
    @IBAction func clear(sender: AnyObject) {
        
        itemFilters!.clear()
        itemFilters!.save()
        
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
        }
        
    }
    
    @IBAction func selectStartDate(sender: AnyObject) {
        askingForStartDate = true
    }
    
    @IBAction func selectEndDate(sender: AnyObject) {
        askingForEndDate = true
    }
    
}
