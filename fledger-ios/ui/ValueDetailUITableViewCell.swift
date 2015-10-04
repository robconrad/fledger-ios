//
//  AmountTableViewCell.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/13/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ValueDetailUITableViewCell: ValueUITableViewCell {
    
    var detailLeft: UILabel = UILabel()
    
    override internal func applySettings() {
        super.applySettings()
        
        detailLeft.font = value.font.fontWithSize(11)
        detailLeft.textColor = AppColors.text()
        
        detailLeft.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(detailLeft)
    }
    
    override internal func getConstraintViews() -> [String : AnyObject] {
        var views = super.getConstraintViews()
        views["detailLeft"] = detailLeft
        return views
    }
    
    override internal func getConstraintFormats() -> [String] {
        return [
            "H:|-[title]-[value(100)]-|",
            "H:|-[detailLeft]-[value(100)]-|",
            "V:|-4-[title]-2-[detailLeft]-2-|",
            "V:|-[value]-|"
        ]
    }
    
}