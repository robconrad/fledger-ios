//
//  AppUIView.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/18/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class AppUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    internal func setup() {
        backgroundColor = AppColors.bgMain()
    }
    
}