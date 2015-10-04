//
//  MainTabBarController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/25/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import UIKit


class MainTabBarController: AppUITabBarController {
    
    enum ViewController: String {
        case Items = "itemsNavController"
        case Overview = "overviewNavController"
        case Settings = "settingsEditViewController"
    }
    
    private let viewControllerIndices: [ViewController] = [.Items, .Overview, .Settings]
    
    override func applyStyle() {
        super.applyStyle()
        
        for vc in viewControllerIndices {
            instantiateView(vc)
        }
    }
    
    private func instantiateView(view: ViewController) {
        let index = viewControllerIndices.indexOf(view)!
        let c = storyboard?.instantiateViewControllerWithIdentifier(view.rawValue)
        self.viewControllers![index] = c!
    }
    
}
