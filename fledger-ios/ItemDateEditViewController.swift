//
//  ItemDateEditViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemDateEditViewController: AppUIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var date: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let d = date {
            datePicker.setDate(d, animated: true)
        }
        
        datePicker.backgroundColor = .whiteColor()
        
    }
    
    @IBAction func selectDate(sender: AnyObject) {
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
            if let dest = nav.viewControllers.last as? ItemEditViewController {
                dest.selectedDate = datePicker.date
            }
            else if let dest = nav.viewControllers.last as? ItemSearchViewController {
                dest.setDate(datePicker.date)
            }
        }
    }
    
}
