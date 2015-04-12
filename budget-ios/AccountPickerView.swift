//
//  AccountViewPicker.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class AccountPickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var accounts: [Account]?

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accounts.map {$0.count} ?? 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return accounts.map {$0[row].name } ?? ""
    }
    
}
