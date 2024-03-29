//
//  SecondViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/9/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit
import FledgerCommon


class OverviewViewController: AppUITableViewController {
    
    @IBOutlet var addButton: UIBarButtonItem!
    
    @IBOutlet var table: UITableView!
    
    private var rows: [Aggregate] = []
    private var sections: [String] = []
    private var sectionIndices: [String] = []
    private var sectionRows: [String:[Aggregate]] = [:]
    private var selectedAggregate: Aggregate?
    
    var category: OverviewCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.sectionIndexBackgroundColor = AppColors.bgHighlight()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sections = []
        sectionIndices = []
        sectionRows = [:]
        rows = getRows()
        for row in rows {
            if let section = row.section {
                if sectionRows[section] == nil {
                    sectionRows[section] = []
                }
                sectionRows[section]!.append(row)
            }
        }
        for section in sectionRows.keys {
            sections.append(section)
        }
        sections.sortInPlace({ left, right in
            return left.lowercaseString < right.lowercaseString
        })
        for section in sections {
            sectionIndices.append(section.substringToIndex(section.startIndex.advancedBy(min(3, section.characters.count))))
        }
        
        table.reloadData()
        
        if category == .All {
            addButton.enabled = false
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count > 0 ? sections.count : 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count > 0 ? sectionRows[sections[section]]!.count : rows.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections.count > 0 ? sections[section] : nil
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = AppColors.text()
        header.contentView.backgroundColor = AppColors.bgHighlight()
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]! {
        return sectionIndices
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ValueDetailUITableViewCell
        
        let aggregate = sections.count > 0 ? sectionRows[sections[indexPath.section]]![indexPath.row] : rows[indexPath.row]
        
        cell.title.text = aggregate.name
        ValueUITableViewCell.setFieldCurrency(cell.value, double: aggregate.value)
        
        if !aggregate.active {
            cell.detailLeft.text = "inactive"
        }
        else {
            cell.detailLeft.text = ""
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedAggregate = sections.count > 0 ? sectionRows[sections[indexPath.section]]![indexPath.row] : rows[indexPath.row]
        return indexPath
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "items" {
            if let dest = segue.destinationViewController as? ItemsViewController {
                let filters = ItemFilters()
                if let aggregate = selectedAggregate {
                    filters.addAggregate(aggregate)
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
    
    private func getRows() -> [Aggregate] {
        if let c = category {
            switch c {
            case .All: return AggregateSvc().getAll()
            case .Account: return AggregateSvc().getAccounts()
            case .Group: return AggregateSvc().getGroups()
            case .Typ: return AggregateSvc().getTypes()
            }
        }
        return []
    }
    
}

