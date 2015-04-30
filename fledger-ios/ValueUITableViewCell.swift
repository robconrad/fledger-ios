//
//  AmountTableViewCell.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/13/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ValueUITableViewCell: AppUITableViewCell {
    
    static let currencyFormatter: NSNumberFormatter = {
        let f = NSNumberFormatter()
        f.numberStyle = .CurrencyStyle
        f.locale = NSLocale(localeIdentifier: "en_US")
        return f
    }()
    
    static let distanceFormatter: NSNumberFormatter = {
        let f = NSNumberFormatter()
        f.numberStyle = .DecimalStyle
        f.maximumFractionDigits = 1
        f.locale = NSLocale(localeIdentifier: "en_US")
        return f
    }()
    
    static func setFieldCurrency(field: UILabel, double: Double) {
        field.text = ValueUITableViewCell.currencyFormatter.stringFromNumber(double)
        if double < 0 {
            field.textColor = AppColors.textError()
        }
        else {
            field.textColor = AppColors.text()
        }
    }
    
    static func setFieldDistance(field: UILabel, double: Double) {
        field.text = ValueUITableViewCell.distanceFormatter.stringFromNumber(double).map { $0 + " km" }
    }
    
    var title: UILabel = UILabel()
    var value: UILabel = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        applySettings()
        applyConstraints()
    }
    
    internal func applySettings() {
        title.textColor = AppColors.text()
        title.font = title.font.fontWithSize(15)
        
        value.alpha = 0.85
        value.textAlignment = .Right
        value.font = value.font.fontWithSize(15)
        value.textColor = AppColors.text()
        
        title.setTranslatesAutoresizingMaskIntoConstraints(false)
        value.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addSubview(title)
        contentView.addSubview(value)
    }
    
    internal func getConstraintViews() -> [NSObject : AnyObject] {
        return [
            "title": title,
            "value": value
        ]
    }
    
    internal func getConstraintFormats() -> [String] {
        return [
            "H:|-[title]-[value(100)]-|",
            "V:|-[title]-|",
            "V:|-[value]-|"
        ]
    }
    
    internal func applyConstraints() {
        let views = getConstraintViews()
        let formats = getConstraintFormats()
        
        for format in formats {
            let constraint = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: views)
            contentView.addConstraints(constraint)
        }
    }
    
}