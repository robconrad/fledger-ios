//
//  AppUINavigationBar.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/15/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class AppUIToolbar: UIToolbar {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        barTintColor = AppColors.bgHeaderHighlight
        
    }
    
}
