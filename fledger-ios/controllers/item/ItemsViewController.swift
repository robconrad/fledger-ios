//
//  FirstViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit
import FledgerCommon


class ItemsViewController: AppUIViewController {
    
    @IBOutlet var table: ItemsTableView!
    
    var itemFilters: ItemFilters?
    var isSearchable = true
    
    private var syncListener: UserDataSyncListener?
    
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
    
    deinit {
        if let listener = syncListener {
            UserSvc().ungregisterSyncListener(listener)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.itemSumOperationFactory = { item, indexPath, itemFilters in
            self.dataQueue.addOperation(ItemSumOperation(item: item, controller: self, indexPath: indexPath, filters: itemFilters))
        }
        
        table.selectRowHandler = { item in
            if let i = item {
                if i.isTransfer() {
                    self.performSegueWithIdentifier("editTransfer", sender: self)
                }
                else {
                    self.performSegueWithIdentifier("editItem", sender: self)
                }
            }
            else if self.isSearchable {
                self.performSegueWithIdentifier("searchItems", sender: self)
            }
        }
        
        if let filters = itemFilters {
            table.itemFilters = filters
        }
        table.itemFilters.count = 30
        table.itemFilters.offset = 0
        
        let listener = UserDataSyncListener { syncType in
            if syncType == .From {
                dispatch_sync(dispatch_get_main_queue()) {
                    self.table.reloadData()
                }
            }
        }
        UserSvc().registerSyncListener(listener)
        syncListener = listener
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // when the view is appearing we reload data because it could have been changed
        table.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        uiQueue.cancelAllOperations()
        dataQueue.cancelAllOperations()
        table.itemSums = [:]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editItem" {
            if let dest = segue.destinationViewController as? ItemEditViewController {
                if let row = table.indexPathForSelectedRow()?.row {
                    let itemIndex = row - table.itemFilters.countFilters()
                    if itemIndex >= 0 {
                        dest.item = table.items?[itemIndex]
                    }
                }
            }
        }
        else if segue.identifier == "editTransfer" {
            if let dest = segue.destinationViewController as? TransferEditViewController {
                if let row = table.indexPathForSelectedRow()?.row {
                    let itemIndex = row - table.itemFilters.countFilters()
                    if itemIndex >= 0 {
                        let firstItem = table.items?[itemIndex]
                        let secondItem = ItemSvc().getTransferPair(firstItem!)
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
                dest.itemFilters = table.itemFilters
            }
        }
        else if segue.identifier == "editAccount" {
            if let dest = segue.destinationViewController as? AccountEditViewController {
                dest.account = table.itemFilters.accountId.map { AccountSvc().withId($0)! }
            }
        }
        else if segue.identifier == "editGroup" {
            if let dest = segue.destinationViewController as? GroupEditViewController {
                dest.group = table.itemFilters.groupId.map { GroupSvc().withId($0)! }
            }
        }
        else if segue.identifier == "editType" {
            if let dest = segue.destinationViewController as? TypeEditViewController {
                dest.type = table.itemFilters.typeId.map { TypeSvc().withId($0)! }
            }
        }
    }
    
    // from overview navigation
    @IBAction func editAction(sender: AnyObject) {
        if table.itemFilters.accountId != nil {
            performSegueWithIdentifier("editAccount", sender: sender)
        }
        else if table.itemFilters.groupId != nil {
            performSegueWithIdentifier("editGroup", sender: sender)
        }
        else if table.itemFilters.typeId != nil {
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
        
        if controller.table.itemSums[item.id!] == nil {
            controller.table.itemSums[item.id!] = ItemSvc().getSum(item, filters: filters)
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



