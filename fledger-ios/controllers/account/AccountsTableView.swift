//
//  AccountTableView.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/2/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import UIKit
import FledgerCommon


class AccountsTableView: AppUITableView, UITableViewDataSource, UITableViewDelegate {
    
    private var accountId: Int64?
    private var accounts: [Account]?
    
    var selectHandler: SelectIdHandler?
    
    override internal func setup() {
        super.setup()
        delegate = self
        dataSource = self
    }
    
    func setAccount(id: Int64) {
        self.accountId = id
        selectAccount()
    }
    
    private func selectAccount() {
        if accountId != nil {
            let index = accounts!.find { $0.id == self.accountId }
            if let i = index {
                let indexPath = NSIndexPath(forRow: i, inSection: 0)
                selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
        }
    }
    
    override func reloadData() {
        accounts = AccountSvc().all().filter { !$0.inactive }
        super.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.map { accounts in accounts.count } ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseIdentifier = "default"
        var label = "failure"
        
        if let account = accounts?[indexPath.row] {
            if account.id == accountId {
                reuseIdentifier = "selected"
            }
            label = account.name
        }
        
        let cell = dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
        cell.textLabel?.text = label
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let handler = selectHandler, accountId = accounts?[indexPath.row].id {
            handler(accountId)
        }
    }

    
}