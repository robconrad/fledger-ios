//
//  ItemsTableViewSuite.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/22/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import XCTest
import fledger_ios


class ItemsTableViewSuite: AppTestSuite {
    
    var view: ItemsTableView!
    var items: [Item]!
    var itemSvc: ItemServiceMock!
    
    override func setUp() {
        super.setUp()
        
        items = [
            Item(id: 1, accountId: 1, typeId: 1, locationId: 1, amount: 1, date: NSDate(), comments: ""),
            Item(id: 2, accountId: 1, typeId: 1, locationId: 1, amount: -1, date: NSDate(), comments: "")
        ]
        
        itemSvc = ItemServiceMock()
        itemSvc.selectResult = items
        Services.register(ItemService.self, itemSvc)
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: self.dynamicType))
        let vc = storyboard.instantiateViewControllerWithIdentifier("ItemsViewController") as! ItemsViewController
        vc.viewDidLoad()
        view = vc.table
    }
    
    func testReloadData() {
        XCTAssertNil(view.items)
        view.reloadData()
        XCTAssertEqual(items, view.items!)
    }
    
}