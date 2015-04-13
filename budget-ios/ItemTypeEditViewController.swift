//
//  Item    EditController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemTypeEditViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var typeId: Int64?
    var types: [Type]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        types = ModelServices.type.all()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.map { types in types.count } ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseIdentifier = "default"
        var label = "failure"
        
        if let type = types?[indexPath.row] {
            if type.id == typeId {
                reuseIdentifier = "selected"
            }
            label = type.name
        }
        
        let cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
        cell.textLabel?.text = label
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
            if let dest = nav.viewControllers.last as? ItemEditViewController {
                dest.selectedTypeId = types![indexPath.row].id
            }
            else if let dest = nav.viewControllers.last as? ItemSearchViewController {
                dest.itemFilters!.typeId = types![indexPath.row].id
            }
        }
    }

}
