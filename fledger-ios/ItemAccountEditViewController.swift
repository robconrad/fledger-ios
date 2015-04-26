//
//  ItemAccountEditController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemAccountEditViewController: AppUITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var accountId: Int64?
    var accounts: [Account]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        accounts = ModelServices.account.all().filter({ !$0.inactive })
        table.reloadData()
        
        if accountId != nil {
            let index = accounts!.find { $0.id == self.accountId }
            if let i = index {
                let indexPath = NSIndexPath(forRow: i, inSection: 0)
                table.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
        }
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
        let accountId = accounts?[indexPath.row].id
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
            if let dest = nav.viewControllers.last as? ItemEditViewController {
                dest.selectedAccountId = accountId
            }
            else if let dest = nav.viewControllers.last as? TransferEditViewController {
                if dest.selectingFromAccount {
                    dest.selectedFromAccountId = accountId
                }
                if dest.selectingIntoAccount {
                    dest.selectedIntoAccountId = accountId
                }
            }
            else if let dest = nav.viewControllers.last as? ItemSearchViewController {
                dest.itemFilters!.accountId = accountId
            }
        }
    }

}
