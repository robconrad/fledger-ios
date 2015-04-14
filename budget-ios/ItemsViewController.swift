//
//  FirstViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var items: [Item]?
    
    var itemFilters = ItemFiltersFromDefaults()
    
    var isSearchable = true
    
    let dateFormat = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        table.delegate = self
        dateFormat.dateFormat = "MM/dd"
        
        itemFilters.count = 30
        itemFilters.offset = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        itemFilters.count = itemFilters.count! + itemFilters.offset!
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
                let comments = i[itemIndex].comments.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                cell.title.text = "\(date) \(type) - \(comments)"
                cell.detail.text = String(format:"$%.2f", i[itemIndex].amount * i[itemIndex].flow)
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
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == itemFilters.count! + itemFilters.offset! - 1 {
            itemFilters.offset! += itemFilters.count!
            items? += ModelServices.item.select(itemFilters)
            table.reloadData()
        }
    }
    
}

