//
//  ItemViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class EditViewController: AppUIViewController {
    
    var errors = false
    
    func segueBack() {
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func checkErrors(errorCondition: Bool, item: UILabel) {
        if errorCondition {
            item.textColor = AppColors.textError
        }
        else {
            item.textColor = AppColors.text
        }
        errors = errors || errorCondition
    }
    
}
