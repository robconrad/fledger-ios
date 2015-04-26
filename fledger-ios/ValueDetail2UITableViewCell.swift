//
//  AmountTableViewCell.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/13/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ValueDetail2UITableViewCell: ValueDetailUITableViewCell {
    
    var detailRight: UILabel = UILabel()
    
    override func applySettings() {
        super.applySettings()
        
        detailRight.alpha = 0.7
        detailRight.font = value.font.fontWithSize(11)
        detailRight.textAlignment = .Right
        detailRight.textColor = AppColors.text()
        
        detailRight.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addSubview(detailRight)
    }
    
    override internal func getConstraintViews() -> [NSObject : AnyObject] {
        var views = super.getConstraintViews()
        views["detailRight"] = detailRight
        return views
    }
    
    override internal func getConstraintFormats() -> [String] {
        return [
            "H:|-[title]-[value(100)]-|",
            "H:|-[detailLeft]-[detailRight(100)]-|",
            "V:|-4-[title]-2-[detailLeft]-2-|",
            "V:|-4-[value]-2-[detailRight]-2-|"
        ]
    }
    
}