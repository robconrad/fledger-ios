//
//  SecondViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    @IBOutlet weak var itemCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemCount.text = "\(model.getItemCount()) items"
        
    }


}

