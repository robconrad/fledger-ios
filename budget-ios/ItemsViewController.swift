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
    
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        table.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        items = model.getItems(count: count + offset, offset: 0)
        table.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.map { items in items.count } ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let id = items.map { items in items[indexPath.row].id } ?? -1
        let comments = items.map { items in items[indexPath.row].comments } ?? "failure"

        cell.textLabel?.text = "\(id) - \(comments)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedRow = indexPath.row
        self.performSegueWithIdentifier("item", sender: table)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "item" {
            if let destination = segue.destinationViewController as? ItemViewController {
                if let row = table.indexPathForSelectedRow()?.row {
                    destination.item = items?[row]
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == count + offset - 1 {
            offset += count
            items? += model.getItems(count: count, offset: offset)
            table.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

