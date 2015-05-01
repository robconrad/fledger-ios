//
//  FirstViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemsViewController: AppUITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var items: [Item]?
    var itemSums = Dictionary<Int64, Double>()
    
    var itemFilters = ItemFiltersFromDefaults()
    
    var isSearchable = true
    
    let dateFormat = NSDateFormatter()
    
    private let dataQueue: NSOperationQueue = {
        var q = NSOperationQueue()
        q.name = "Items View Sum Background/Data Queue"
        q.maxConcurrentOperationCount = 5
        return q
    }()
    
    private let uiQueue: NSOperationQueue = {
        var q = NSOperationQueue()
        q.name = "Items View Sum Foreground/UI Queue"
        q.maxConcurrentOperationCount = 1
        return q
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        dateFormat.dateFormat = "YYYY-MM-dd"
        
        itemFilters.count = 30
        itemFilters.offset = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // when the view is appearing we reload data because it could habe been changed
        // we have to pull the entire amount of data that has been pulled through infinite scrolling so that the table can
        //  be scrolled to the same point the user left (e.g. when leaving to edit item #100 and returning)
        itemFilters.count = itemFilters.offset! + itemFilters.count!
        itemFilters.offset = 0
        items = ModelServices.item.select(itemFilters)
        table.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        uiQueue.cancelAllOperations()
        dataQueue.cancelAllOperations()
        itemSums = [:]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemFilters.count() + (items.map { items in items.count } ?? 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let itemIndex = indexPath.row - itemFilters.count() 
        
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
                    
                    dataQueue.addOperation(ItemSumOperation(item: item, controller: self, indexPath: indexPath, filters: itemFilters))
                }
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("filter") as! UITableViewCell
            
            cell.textLabel?.text = itemFilters.strings()[indexPath.row]
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let itemIndex = indexPath.row - itemFilters.count()
        if itemIndex >= 0 {
            if items![itemIndex].isTransfer() {
                self.performSegueWithIdentifier("editTransfer", sender: self)
            }
            else {
                self.performSegueWithIdentifier("editItem", sender: self)
            }
        }
        else if isSearchable {
            self.performSegueWithIdentifier("searchItems", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editItem" {
            if let dest = segue.destinationViewController as? ItemEditViewController {
                if let row = table.indexPathForSelectedRow()?.row {
                    let itemIndex = row - itemFilters.count()
                    if itemIndex >= 0 {
                        dest.item = items?[itemIndex]
                    }
                }
            }
        }
        else if segue.identifier == "editTransfer" {
            if let dest = segue.destinationViewController as? TransferEditViewController {
                if let row = table.indexPathForSelectedRow()?.row {
                    let itemIndex = row - itemFilters.count()
                    if itemIndex >= 0 {
                        let firstItem = items?[itemIndex]
                        let secondItem = ModelServices.item.getTransferPair(firstItem!)
                        if firstItem?.amount < 0 {
                            dest.fromItem = firstItem
                            dest.intoItem = secondItem
                        }
                        else {
                            dest.intoItem = firstItem
                            dest.fromItem = secondItem
                        }
                    }
                }
            }
        }
        else if segue.identifier == "searchItems" {
            if let dest = segue.destinationViewController as? ItemSearchViewController {
                dest.itemFilters = itemFilters
            }
        }
        else if segue.identifier == "editAccount" {
            if let dest = segue.destinationViewController as? AccountEditViewController {
                dest.account = itemFilters.accountId.map { ModelServices.account.withId($0)!  }
            }
        }
        else if segue.identifier == "editGroup" {
            if let dest = segue.destinationViewController as? GroupEditViewController {
                dest.group = itemFilters.groupId.map { ModelServices.group.withId($0)!  }
            }
        }
        else if segue.identifier == "editType" {
            if let dest = segue.destinationViewController as? TypeEditViewController {
                dest.type = itemFilters.typeId.map { ModelServices.type.withId($0)!  }
            }
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        // TODO do the reload in a background thread so scrolling is still smooth
        // TODO do the reload when we are halfway to needing it
        // TODO do we need to reload all the data? can't we incrementally add data? should infinite scrolling be a sliding window that reloads in either direction??
        if indexPath.row == itemFilters.count! + itemFilters.offset! - 1 {
            itemFilters.offset! += itemFilters.count!
            items? += ModelServices.item.select(itemFilters)
            table.reloadData()
        }
    }
    
    // from overview navigation
    @IBAction func editAction(sender: AnyObject) {
        if itemFilters.accountId != nil {
            performSegueWithIdentifier("editAccount", sender: sender)
        }
        else if itemFilters.groupId != nil {
            performSegueWithIdentifier("editGroup", sender: sender)
        }
        else if itemFilters.typeId != nil {
            performSegueWithIdentifier("editType", sender: sender)
        }
    }
    
}

class ItemSumOperation: NSOperation {
    
    let item: Item
    let controller: ItemsViewController
    let indexPath: NSIndexPath
    let filters: ItemFilters
    
    init(item: Item, controller: ItemsViewController, indexPath: NSIndexPath, filters: ItemFilters) {
        self.item = item
        self.controller = controller
        self.indexPath = indexPath
        self.filters = filters
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        if controller.itemSums[item.id!] == nil {
            controller.itemSums[item.id!] = ModelServices.item.getSum(item, filters: filters)
        }
        else {
            return
        }
        
        if self.cancelled {
            return
        }
        
        if controller.uiQueue.operationCount == 0 {
            controller.uiQueue.addOperation(ReloadTableOperation(controller: controller))
        }
    }
    
}

class ReloadTableOperation: NSOperation {
    
    let controller: ItemsViewController
    
    init(controller: ItemsViewController) {
        self.controller = controller
    }
    
    override func main() {
        if self.cancelled {
            return
        }
        
        dispatch_sync(dispatch_get_main_queue()) {
            self.controller.table.reloadData()
        }
    }
    
}



