//
//  HighlightUITableViewCell.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/14/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class HighlightUITableViewCell: AppUITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = AppColors.bgHighlight
        
    }

}
