//
//  AppUITableViewCell.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/14/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class AppUITableViewCell: UITableViewCell {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = AppColors.bgMain()
        textLabel?.textColor = AppColors.text()
        
        let selectedBgView = UIView()
        selectedBgView.backgroundColor = AppColors.bgSelected()
        selectedBackgroundView = selectedBgView
    }
    
}
