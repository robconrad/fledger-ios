//
//  AppUINavigationBar.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/15/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class AppUINavigationBar: UINavigationBar, CanStyle {
    
    func applyStyle() {
        
        barTintColor = AppColors.bgHeaderHighlight()
        titleTextAttributes = [NSForegroundColorAttributeName: AppColors.text()]
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applyStyle()
    }
    
}
