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
    
    var selected: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        types = ModelServices.type.all()
        table.reloadData()
        
        if typeId != nil {
            let index = types!.find { $0.id == self.typeId }
            if let i = index {
                let indexPath = NSIndexPath(forRow: i, inSection: 0)
                table.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types?.count ?? 0
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
        let typeId = types?[indexPath.row].id
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
