//
//  AppStyle.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/14/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation


class AppColors {
    
    static let bgMain = UIColor.blackColor()
    static let bgHighlightTransient = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1)
    static let bgHighlight = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
    static let bgHeader = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
    static let bgHeaderHighlight = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1)
    
    static let text = UIColor.whiteColor()
    static let textWeak = AppColors.bgHeader
    static let textError = UIColor.redColor()
    
}
