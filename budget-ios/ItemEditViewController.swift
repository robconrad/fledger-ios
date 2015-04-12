//
//  ItemViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import Foundation
import UIKit

class ItemEditViewController: UIViewController {
    
//    @IBOutlet weak var scroller: UIScrollView!
//    @IBOutlet weak var accountOutlet: AccountPickerView!
//    @IBOutlet weak var typeOutlet: TypePickerView!
//    @IBOutlet weak var amountOutlet: UITextField!
//    @IBOutlet weak var dateOutlet: UIDatePicker!
//    @IBOutlet weak var commentsOutlet: UITextView!
//    
//    var item: Item?
//    
//    let cmp = 0
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        accountOutlet.delegate = accountOutlet
//        accountOutlet.dataSource = accountOutlet
//        
//        typeOutlet.delegate = typeOutlet
//        typeOutlet.dataSource = typeOutlet
//        
//        typeOutlet.types = model.getTypes()
//        accountOutlet.accounts = model.getAccounts()
//        
//        if let i = item {
//            
//            var accountRow = 0
//            for (idx, e) in enumerate(accountOutlet.accounts!) {
//                if (e.id == i.accountId) {
//                    accountRow = idx
//                }
//            }
//            
//            var typeRow = 0
//            for (idx, e) in enumerate(typeOutlet.types!) {
//                if (e.id == i.typeId) {
//                    typeRow = idx
//                }
//            }
//            
//            accountOutlet.selectRow(accountRow, inComponent: cmp, animated: true)
//            typeOutlet.selectRow(typeRow, inComponent: cmp, animated: true)
//            amountOutlet.text = String(format: "%.2f", i.amount)
//            dateOutlet.setDate(i.date, animated: true)
//            commentsOutlet.text = i.comments
//        }
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        scroller.scrollEnabled = true
//        scroller.contentSize = CGSize(width: scroller.contentSize.width, height: 1400)
//        scroller.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
//    }
//    
//    @IBAction func save(sender: AnyObject) {
//    
//        if let i: Item = item {
//            model.updateItem(i.copy(
//                accountId: Int64(accountOutlet.accounts![accountOutlet.selectedRowInComponent(cmp)].id),
//                typeId: Int64(typeOutlet.types![accountOutlet.selectedRowInComponent(cmp)].id),
//                amount: (amountOutlet.text as NSString).doubleValue,
//                date: dateOutlet.date,
//                comments: commentsOutlet.text))
//        }
//        
//        if let nav = navigationController {
//            nav.popToRootViewControllerAnimated(true)
//        }
//    }
//    
//    func hideKeyboard() {
//        self.view.endEditing(true)
//    }
    
}
