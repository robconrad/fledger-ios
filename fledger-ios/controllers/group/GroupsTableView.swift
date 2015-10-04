//
//  AccountTableView.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/2/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import UIKit
import FledgerCommon


class GroupsTableView: AppUITableView, UITableViewDataSource, UITableViewDelegate {
    
    private var groupId: Int64?
    private var groups: [Group]?
    
    var selectHandler: SelectIdHandler?
    
    override internal func setup() {
        super.setup()
        delegate = self
        dataSource = self
    }
    
    func setGroup(id: Int64) {
        self.groupId = id
        selectGroup()
    }
    
    private func selectGroup() {
        if groupId != nil {
            let index = groups!.find { $0.id == self.groupId }
            if let i = index {
                let indexPath = NSIndexPath(forRow: i, inSection: 0)
                selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
        }
    }
    
    override func reloadData() {
        groups = GroupSvc().all()
        super.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseIdentifier = "default"
        var label = "failure"
        
        if let group = groups?[indexPath.row] {
            if group.id == groupId {
                reuseIdentifier = "selected"
            }
            label = group.name
        }
        
        let cell = dequeueReusableCellWithIdentifier(reuseIdentifier)!
        cell.textLabel?.text = label
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let handler = selectHandler, groupId = groups?[indexPath.row].id {
            handler(groupId)
        }
    }
    
}