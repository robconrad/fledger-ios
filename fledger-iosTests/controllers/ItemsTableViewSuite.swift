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
    
    let defaultCount = 2
    let defaultOffset = 0
    
    var view: ItemsTableView!
    var items: [Item]!
    var filters: ItemFilters!
    var itemSvc: ItemServiceMock!
    
    override func setUp() {
        super.setUp()
        
        let item = Item(id: 0, accountId: 1, typeId: 1, locationId: 1, amount: 1, date: NSDate(), comments: "")
        
        items = [
            item.withId(1),
            item.withId(2)
        ]
        
        filters = ItemFilters()
        filters.count = defaultCount
        filters.offset = defaultOffset
        
        itemSvc = ItemServiceMock()
        itemSvc.selectResult = items
        itemSvc.getFiltersFromDefaultsResult = filters
        Services.register(ItemService.self, itemSvc)
    }
    
    func testReloadData() {
        
        let view = ItemsTableView(frame: CGRect(), style: .Plain)
        
        XCTAssertNil(view.items)
        XCTAssert(view.itemFilters == filters)
        view.reloadData()
        XCTAssertEqual(items, view.items!)
        XCTAssert(view.itemFilters.count == defaultCount)
        XCTAssert(view.itemFilters.offset == defaultOffset)
        view.itemFilters.offset = defaultCount
        view.reloadData()
        XCTAssert(view.itemFilters.count == defaultCount * 2)
        XCTAssert(view.itemFilters.offset == defaultOffset)
        
    }
    
    func testCellForRowAtIndexPath() {
        
//        let view = ItemsTableView(frame: CGRect(), style: .Plain)
//        let cell = nil
//        let index = 1
//
//        view.tableView(view, cellForRowAtIndexPath: NSIndexPath(forRow: Index, inSection: 0))
        
    }
    
    func testDidSelectRowAtIndexPath() {
        
        let view = ItemsTableView(frame: CGRect(), style: .Plain)
        let index = 1
        
        view.reloadData()
        
        var selected = false
        view.selectRowHandler = { item in
            XCTAssertEqual(item!, self.items[index])
            selected = true
        }
        
        view.tableView(view, didSelectRowAtIndexPath: NSIndexPath(forRow: index, inSection: 0))
        XCTAssert(selected)
        
    }
    
    func testWillDisplayCell() {
        
//        let view = ItemsTableView(frame: CGRect(), style: .Plain)
//        let cell = nil
//        let index = 1
//        
//        view.tableView(view, willDisplayCell: cell, forRowAtIndexPath: NSIndexPath(index: index, inSection: 0))
        
    }
    
}