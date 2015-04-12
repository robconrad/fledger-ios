//
//  ItemDateEditViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemDateEditViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var date: NSDate?
    
    override func viewDidLoad() {
        
        if let d = date {
            datePicker.setDate(d, animated: true)
        }
        
    }
    
    @IBAction func selectDate(sender: AnyObject) {
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
            if let dest = nav.viewControllers.last as? ItemViewController {
                dest.item = dest.item?.copy(date: datePicker.date)
            }
        }
    }
    
}
