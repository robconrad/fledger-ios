//
//  AccountTableView.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/2/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import UIKit


class TypesTableView: AppUITableView, UITableViewDataSource, UITableViewDelegate {
    
    private var typeId: Int64?
    private var types: [Type]?
    
    private var sections: [String] = []
    private var sectionIndices: [String] = []
    private var sectionRows: [String: [Type]] = [:]
    
    private var selected: NSIndexPath?
    
    var selectHandler: SelectIdHandler?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        dataSource = self
        sectionIndexBackgroundColor = AppColors.bgHighlight()
    }
    
    func setType(id: Int64) {
        self.typeId = id
        selectType()
    }
    
    private func selectType() {
        if typeId != nil {
            let type = types!.filter { $0.id == self.typeId }.first!
            let section = type.group().name
            let index = sectionRows[section]?.find { $0.id == self.typeId }
            if let i = index {
                let indexPath = NSIndexPath(forRow: i, inSection: sections.find { $0 == section }!)
                selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
        }
    }
    
    override func reloadData() {
        sections = []
        sectionRows = [:]
        types = Services.get(TypeService.self).all()
        
        for type in types! {
            let section = type.group().name
            if sectionRows[section] == nil {
                sectionRows[section] = []
            }
            sectionRows[section]!.append(type)
        }
        for section in sectionRows.keys {
            sections.append(section)
        }
        sections = sorted(sections, { left, right in
            return left.lowercaseString < right.lowercaseString
        })
        for section in sections {
            sectionIndices.append(section.substringToIndex(advance(section.startIndex, min(3, count(section)))))
        }
        
        super.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionRows[sections[section]]!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel.textColor = AppColors.text()
        header.contentView.backgroundColor = AppColors.bgHighlight()
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return sectionIndices
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseIdentifier = "default"
        var label = "failure"
        
        if let type = sectionRows[sections[indexPath.section]]?[indexPath.row] {
            if type.id == typeId {
                reuseIdentifier = "selected"
            }
            label = type.name
        }
        
        let cell = dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
        cell.textLabel?.text = label
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let handler = selectHandler, typeId = self.sectionRows[sections[indexPath.section]]?[indexPath.row].id {
            handler(typeId)
        }
    }
    
}