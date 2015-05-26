//
//  AppUITableViewCell.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/14/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class AppUITableView: UITableView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    required override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    internal func setup() {
        backgroundColor = AppColors.bgMain()
    }
    
}
