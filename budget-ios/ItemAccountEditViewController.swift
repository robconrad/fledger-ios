//
//  ItemAccountEditController.swift
//  budget-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemAccountEditViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var accountId: Int64?
    var accounts: [Account]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        accounts = accountManager.all().filter({ !$0.inactive })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.map { accounts in accounts.count } ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseIdentifier = "default"
        var label = "failure"
        
        if let account = accounts?[indexPath.row] {
            if account.id == accountId {
                reuseIdentifier = "selected"
            }
            label = account.name
        }
        
        let cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
        cell.textLabel?.text = label
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
            if let dest = nav.viewControllers.last as? ItemEditViewController {
                dest.selectedAccountId = accounts![indexPath.row].id
            }
            else if let dest = nav.viewControllers.last as? ItemSearchViewController {
                dest.itemFilters!.accountId = accounts![indexPath.row].id
            }
        }
    }

}
