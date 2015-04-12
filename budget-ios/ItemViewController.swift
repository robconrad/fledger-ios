//
//  ItemViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    
    @IBOutlet weak var account: UIButton!
    @IBOutlet weak var date: UIButton!
    @IBOutlet weak var type: UIButton!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var comments: UITextView!
    
    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
  
    override func viewWillAppear(animated: Bool) {
        
        if let i = item {
            account.setTitle(i.account().name, forState: .Normal)
            date.setTitle(i.date.datatypeValue, forState: .Normal)
            type.setTitle(i.type().name, forState: .Normal)
            amount.text = String(format: "%.2f", i.amount)
            comments.text = i.comments
        }
        
    }

    @IBAction func save(sender: AnyObject) {
        
        if let i: Item = item {
            model.updateItem(i.copy(
                amount: (amount.text as NSString).doubleValue,
                comments: comments.text))
        }
        
        if let nav = navigationController {
            nav.popToRootViewControllerAnimated(true)
        }
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
