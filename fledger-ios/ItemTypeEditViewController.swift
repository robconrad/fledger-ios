//
//  Item    EditController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemTypeEditViewController: AppUITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var typeId: Int64?
    var types: [Type]?
    
    var sections: [String] = []
    var sectionIndices: [String] = []
    var sectionRows: [String: [Type]] = [:]
    
    var selected: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.sectionIndexBackgroundColor = AppColors.bgHighlight()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        sections = []
        sectionRows = [:]
        types = ModelServices.type.all()
        
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
        
        table.reloadData()
        
        if typeId != nil {
            let type = types!.filter { $0.id == self.typeId }.first!
            let section = type.group().name
            let index = sectionRows[section]?.find { $0.id == self.typeId }
            if let i = index {
                let indexPath = NSIndexPath(forRow: i, inSection: sections.find { $0 == section }!)
                table.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionRows[sections[section]]!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel.textColor = AppColors.text()
        header.contentView.backgroundColor = AppColors.bgHighlight()
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return sectionIndices
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseIdentifier = "default"
        var label = "failure"
        
        if let type = sectionRows[sections[indexPath.section]]?[indexPath.row] {
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
        let typeId = self.sectionRows[sections[indexPath.section]]![indexPath.row].id
        if let nav = navigationController {
            let destination: AnyObject = nav.viewControllers[nav.viewControllers.count - 2]
            if let dest = destination as? ItemEditViewController {
                if typeId == ModelServices.type.transferId {
                    if let transferController = storyboard?.instantiateViewControllerWithIdentifier("transferEditViewController") as? TransferEditViewController {
                        transferController.selectedDate = dest.selectedDate
                        if dest.flow.on {
                            transferController.selectedIntoAccountId = dest.selectedAccountId
                        }
                        else {
                            transferController.selectedFromAccountId = dest.selectedAccountId
                        }
                        nav.viewControllers[nav.viewControllers.count - 2] = transferController
                    }
                }
                else {
                    dest.selectedTypeId = typeId
                }
            }
            else if let dest = destination as? TransferEditViewController {
                if typeId != ModelServices.type.transferId {
                    if let controller = storyboard?.instantiateViewControllerWithIdentifier("itemEditViewController") as? ItemEditViewController {
                        controller.selectedTypeId = typeId
                        controller.selectedDate = dest.selectedDate
                        controller.selectedAccountId = dest.selectedFromAccountId
                        nav.viewControllers[nav.viewControllers.count - 2] = controller
                    }
                }
            }
            else if let dest = destination as? ItemSearchViewController {
                dest.itemFilters!.typeId = typeId
            }
            nav.popViewControllerAnimated(true)
        }
    }

}
