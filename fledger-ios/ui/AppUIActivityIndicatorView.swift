//
//  File.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/26/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import Foundation


class AppUIActivityIndicatorView: UIActivityIndicatorView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = AppColors.bgMain()
        color = AppColors.text()
    }
    
}