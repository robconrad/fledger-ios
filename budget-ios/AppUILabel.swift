//
//  AppUILabel.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/14/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class AppUILabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textColor? = AppColors.text
    }
    
}
