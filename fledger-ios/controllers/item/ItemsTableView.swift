//
//  ItemsTableView.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/14/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import UIKit
import FledgerCommon


class ItemsTableView: AppUITableView, UITableViewDataSource, UITableViewDelegate {
    
    var items: [Item]?
    var itemSums = Dictionary<Int64, Double>()
    
    lazy var itemFilters: ItemFilters = ItemSvc().getFiltersFromDefaults()
    
    var itemSumOperationFactory: ((Item, NSIndexPath, ItemFilters) -> Void)?
    var selectRowHandler: ((Item?) -> Void)?
    
    private let dateFormat: NSDateFormatter = {
        let df = NSDateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
        }()
    
    override internal func setup() {
        super.setup()
        delegate = self
        dataSource = self
    }
    
    override func reloadData() {
        // we have to pull the entire amount of data that has been pulled through infinite scrolling so that the table can
        //  be scrolled to the same point the user left (e.g. when leaving to edit item #100 and returning)
        itemFilters.count = itemFilters.offset! + itemFilters.count!
        itemFilters.offset = 0
        items = ItemSvc().select(itemFilters)
        super.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemFilters.countFilters() + (items.map { items in items.count } ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let itemIndex = indexPath.row - itemFilters.countFilters()
        
        if itemIndex >= 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("default") as! ValueDetail2UITableViewCell
            
            if let i = items {
                let item = i[itemIndex]
                let date = dateFormat.stringFromDate(i[itemIndex].date)
                let type = item.type().name
                let group = item.group().name
                let comments = item.comments.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                cell.title.text = "\(comments)"
                cell.detailLeft.text = "\(date) - \(group) - \(type)"
                ValueUITableViewCell.setFieldCurrency(cell.value, double: item.amount)
                
                if let sum = itemSums[item.id!] {
                    ValueUITableViewCell.setFieldCurrency(cell.detailRight, double: sum)
                }
                else {
                    cell.detailRight.text = "-"
                    cell.detailRight.textColor = AppColors.text()
                    
                    itemSumOperationFactory?(item, indexPath, itemFilters)
                }
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("filter")!
            
            cell.textLabel?.text = itemFilters.strings()[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let itemIndex = indexPath.row - itemFilters.countFilters()
        selectRowHandler?(itemIndex >= 0 ? items![itemIndex] : nil)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // TODO do the reload in a background thread so scrolling is still smooth
        // TODO do the reload when we are halfway to needing it
        // TODO do we need to reload all the data? can't we incrementally add data? should infinite scrolling be a sliding window that reloads in either direction??
        if indexPath.row == itemFilters.count! + itemFilters.offset! - 1 {
            itemFilters.offset! += itemFilters.count!
            items? += ItemSvc().select(itemFilters)
            reloadData()
        }
    }
    
}