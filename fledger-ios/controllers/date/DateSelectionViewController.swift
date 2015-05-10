//
//  ItemDateEditViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class DateSelectionViewController: AppUIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var date: NSDate?
    var selectHandler: SelectDateHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let d = date {
            datePicker.setDate(d, animated: true)
        }
        
        datePicker.backgroundColor = .whiteColor()
    }
    
    @IBAction func selectDate(sender: AnyObject) {
        selectHandler.map { $0(datePicker.date) }
        navigationController?.popViewControllerAnimated(true)
    }
    
}
