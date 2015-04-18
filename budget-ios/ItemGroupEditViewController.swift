//
//  Item    EditController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemGroupEditViewController: AppUITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var groupId: Int64?
    var groups: [Group]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        groups = ModelServices.group.all()
        table.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseIdentifier = "default"
        var label = "failure"
        
        if let group = groups?[indexPath.row] {
            if group.id == groupId {
                reuseIdentifier = "selected"
            }
            label = group.name
        }
        
        let cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
        cell.textLabel?.text = label
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
            if let dest = nav.viewControllers.last as? TypeEditViewController {
                dest.selectedGroupId = groups![indexPath.row].id
            }
            else if let dest = nav.viewControllers.last as? ItemSearchViewController {
                dest.itemFilters!.groupId = groups![indexPath.row].id
            }
        }
    }

}
