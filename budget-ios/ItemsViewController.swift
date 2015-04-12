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
    var offset = 0
    let count = 30
    
    var itemFilters = ItemFiltersFromDefaults()
    
    let dateFormat = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        table.delegate = self
        dateFormat.dateFormat = "MM/dd"
    }
    
    override func viewWillAppear(animated: Bool) {
        items = getItems(0, count: count + offset)
        table.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemFilters.count() + (items.map { items in items.count } ?? 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let itemIndex = indexPath.row - itemFilters.count()
        
        if itemIndex >= 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("default") as! UITableViewCell

            let date = items.map { items in
                let date = items[itemIndex].date
                return self.dateFormat.stringFromDate(date)
            } ?? "failure"
            let type = items.map { items in items[itemIndex].type().name } ?? "failure"
            let comments = items.map { items in items[itemIndex].comments.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) } ?? "failure"

            cell.textLabel?.text = "\(date) \(type) - \(comments)"
            
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
        else {
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
        if indexPath.row == count + offset - 1 {
            offset += count
            items? += getItems(offset, count: count)
            table.reloadData()
        }
    }
    
    func getItems(offset: Int, count: Int) -> [Item] {
        return model.getItems(
            offset: offset,
            count: count,
            itemFilters: itemFilters)
    }

}

