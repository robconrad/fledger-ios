//
//  SecondViewController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit


class OverviewViewController: AppUITableViewController {
    
    @IBOutlet var addButton: UIBarButtonItem!
    
    @IBOutlet var table: UITableView!
    
    private var rows: [Aggregate] = []
    private var selectedIndex: Int?
    
    var category: OverviewCategory?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        rows = getAggregator()()
        table.reloadData()
        
        if category == .All {
            addButton.enabled = false
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DetailUITableViewCell
        
        let aggregate = rows[indexPath.row]
        
        cell.title.text = aggregate.name
        cell.setDetailCurrency(aggregate.value)
        
        if !aggregate.active {
            cell.subDetail.text = "inactive"
        }
        
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

    @IBAction func addAction(sender: AnyObject) {
        if let c = category {
            switch c {
            case .Account: performSegueWithIdentifier("addAccount", sender: sender)
            case .Group: performSegueWithIdentifier("addGroup", sender: sender)
            case .Typ: performSegueWithIdentifier("addType", sender: sender)
            default: break
            }
        }
    }
    
    func getAggregator() -> (() -> [Aggregate]) {
        if let c = category {
            switch c {
            case .All: return Aggregates.getAll
            case .Account: return Aggregates.getAccounts
            case .Group: return Aggregates.getGroups
            case .Typ: return Aggregates.getTypes
            }
        }
        return { _ in [] }
    }
    
}

