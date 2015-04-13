//
//  SecondViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class OverviewsViewController: UITableViewController {
    
    let categories = ["All", "Accounts", "Groups", "Types"]
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedIndex = indexPath.row
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "overview" {
            if let dest = segue.destinationViewController as? OverviewViewController {
                if let index = selectedIndex {
                    dest.title = categories[index]
                    switch index {
                    case 0: dest.rows = Aggregates.getAll()
                    case 1: dest.rows = Aggregates.getAccounts()
                    case 2: dest.rows = Aggregates.getGroups()
                    case 3: dest.rows = Aggregates.getTypes()
                    default: break
                    }
                }
            }
        }
    }

}

