//
//  AppUITextField.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/15/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class AppUIViewField: UITextView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = AppColors.bgHighlight()
        textColor = AppColors.text()
        
    }
    
}
