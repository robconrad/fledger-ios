//
//  AppStyle.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/14/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation

class AppColors {
    
    enum Token {
        case bgMain
        case bgHighlightTransient
        case bgHighlight
        case bgHeader
        case bgHeaderHighlight
        case text
        case textError
    }
    
    // favorite blue: UIColor(red: 13/255, green: 138/255, blue: 245/255, alpha: 1)
    
    private static let darkColors: [Token: UIColor] = [
        Token.bgMain: UIColor.blackColor(),
        Token.bgHighlightTransient: UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1),
        Token.bgHighlight: UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1),
        Token.bgHeader: UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1),
        Token.bgHeaderHighlight: UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 1),
        Token.text: UIColor.whiteColor(),
        Token.textError: UIColor.redColor()
    ]
    
    private static let lightColors: [Token: UIColor] = [
        Token.bgMain: UIColor.whiteColor(),
        Token.bgHighlightTransient: UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1),
        Token.bgHighlight: UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 1),
        Token.bgHeader: UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1),
        Token.bgHeaderHighlight: UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1),
        Token.text: UIColor.blackColor(),
        Token.textError: UIColor.redColor()
    ]
    
    private static func get(token: Token) -> UIColor {
        switch AppStyling.get() {
        case .Light: return lightColors[token]!
        case .Dark: return darkColors[token]!
        }
    }
    
    static func bgMain() -> UIColor { return get(Token.bgMain) }
    static func bgHighlightTransient() -> UIColor { return get(Token.bgHighlightTransient) }
    static func bgHighlight() -> UIColor { return get(Token.bgHighlight) }
    static func bgSelected() -> UIColor { return get(Token.bgHighlightTransient) }
    static func bgHeader() -> UIColor { return get(Token.bgHeader) }
    static func bgHeaderHighlight() -> UIColor { return get(Token.bgHeaderHighlight) }
    
    static func text() -> UIColor { return get(Token.text) }
    static func textWeak() -> UIColor { return AppColors.bgHeader() }
    static func textError() -> UIColor { return get(Token.textError) }
    
}
