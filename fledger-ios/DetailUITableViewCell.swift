//
//  AmountTableViewCell.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/13/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class DetailUITableViewCell: AppUITableViewCell {
    
    static let formatter: NSNumberFormatter = {
        let f = NSNumberFormatter()
        f.numberStyle = .CurrencyStyle
        f.locale = NSLocale(localeIdentifier: "en_US")
        return f
    }()
    
    var title: UILabel = UILabel()
    var detail: UILabel = UILabel()
    var subDetail: UILabel = UILabel()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        title.textColor = AppColors.text
        
        detail.alpha = 0.75
        detail.textAlignment = .Right
        detail.font = detail.font.fontWithSize(15)
        detail.textColor = AppColors.text
        
        subDetail.font = detail.font.fontWithSize(11)
        subDetail.textColor = AppColors.text
        
        title.setTranslatesAutoresizingMaskIntoConstraints(false)
        detail.setTranslatesAutoresizingMaskIntoConstraints(false)
        subDetail.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addSubview(title)
        contentView.addSubview(detail)
        contentView.addSubview(subDetail)
        
        let views = ["title": title, "detail": detail, "subDetail": subDetail]
        let constraintFormats = ["H:|-[title]-[detail(100)]-|", "H:|-[subDetail]-|", "V:|-4-[title]-2-[subDetail]-2-|", "V:|-[detail]-|"]
        
        for format in constraintFormats {
            let constraint = NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(0), metrics: nil, views: views)
            contentView.addConstraints(constraint)
        }
    }
    
    func setDetailCurrency(value: Double) {
        detail.text = DetailUITableViewCell.formatter.stringFromNumber(value)
        if value < 0 {
            detail.textColor = AppColors.textError
        }
        else {
            detail.textColor = AppColors.text
        }
    }
    
}