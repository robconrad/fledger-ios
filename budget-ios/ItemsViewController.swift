//
//  FirstViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemsViewController: AppUITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var items: [Item]?
    
    var itemFilters = ItemFiltersFromDefaults()
    
    var isSearchable = true
    
    let dateFormat = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        dateFormat.dateFormat = "YYYY-MM-dd"
        
        itemFilters.count = 30
        itemFilters.offset = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        // when the view is appearing we reload data because it could habe been changed
        // we have to pull the entire amount of data that has been pulled through infinite scrolling so that the table can
        //  be scrolled to the same point the user left (e.g. when leaving to edit item #100 and returning)
        itemFilters.count = itemFilters.offset! + itemFilters.count!
        itemFilters.offset = 0
        items = ModelServices.item.select(itemFilters)
        table.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemFilters.count() + (items.map { items in items.count } ?? 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let itemIndex = indexPath.row - itemFilters.count() 
        
        if itemIndex >= 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("default") as! DetailUITableViewCell
            
            if let i = items {
                let date = dateFormat.stringFromDate(i[itemIndex].date)
                let type = i[itemIndex].type().name
                let group = i[itemIndex].group().name
                let comments = i[itemIndex].comments.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                cell.title.text = "\(comments)"
                cell.subDetail.text = "\(date) - \(group) - \(type)"
                cell.setDetailCurrency(i[itemIndex].amount)
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
            self.performSegueWithIdentifier("editItem", sender: table)
        }
        else if isSearchable {
            self.performSegueWithIdentifier("searchItems", sender: table)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editItem" {
            if let destination = segue.destinationViewController as? ItemEditViewController {
                if let row = table.indexPathForSelectedRow()?.row {
                    let itemIndex = row - itemFilters.count()
                    if itemIndex >= 0 {
                        destination.item = items?[itemIndex]
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

