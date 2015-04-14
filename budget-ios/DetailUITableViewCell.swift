//
//  AmountTableViewCell.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/13/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import UIKit

class DetailUITableViewCell: UITableViewCell {
    
    var title: UILabel = UILabel()
    var detail: UILabel = UILabel()
    
    override func awakeFromNib() {
        
        detail.textColor = UIColor.grayColor()
        detail.font = detail.font.fontWithSize(15)
        
        title.setTranslatesAutoresizingMaskIntoConstraints(false)
        detail.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        contentView.addSubview(title)
        contentView.addSubview(detail)
        
        let views = ["title": title, "detail": detail]
        let constraints = ["H:|-[title]-[detail(<=100)]-|", "V:|-[title]-|", "V:|-[detail]-|"]
        
        for constraint in constraints {
            contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(constraint, options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        }
    }
    
}