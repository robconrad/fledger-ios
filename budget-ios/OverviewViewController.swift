//
//  SecondViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class OverviewViewController: UITableViewController {
    
    var rows: [Aggregate] = []
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DetailUITableViewCell
        
        cell.title.text = rows[indexPath.row].name
        cell.setDetailCurrency(rows[indexPath.row].value)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "items" {
            if let dest = segue.destinationViewController as? ItemsViewController {
                let filters = ItemFilters()
                if let index = selectedIndex {
                    filters.addAggregate(rows[index])
                }
                dest.itemFilters = filters
                dest.isSearchable = false
            }
        }
    }

}

