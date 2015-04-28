//
//  ItemlocationEditController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit

class ItemLocationEditViewController: AppUIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var locationId: Int64?
    var locations: [Location]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locations = ModelServices.location.all()
        table.reloadData()
        
        if locationId == nil {
            deleteButton.enabled = false
        }
        else {
            deleteButton.enabled = true
            
            let index = locations!.find { $0.id == self.locationId }
            if let i = index {
                let indexPath = NSIndexPath(forRow: i, inSection: 0)
                table.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.map { locations in locations.count } ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reuseIdentifier = "default"
        var label = "failure"
        
        if let location = locations?[indexPath.row] {
            if location.id == locationId {
                reuseIdentifier = "selected"
            }
            label = location.title()
        }
        
        let cell = table.dequeueReusableCellWithIdentifier(reuseIdentifier) as! UITableViewCell
        cell.textLabel?.text = label
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let locationId = locations?[indexPath.row].id
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
            if let dest = nav.viewControllers.last as? ItemEditViewController {
                dest.selectedLocationId = locationId
            }
        }
    }
    
    @IBAction func deleteLocation(sender: AnyObject) {
        if let nav = navigationController {
            nav.popViewControllerAnimated(true)
            if let dest = nav.viewControllers.last as? ItemEditViewController {
                dest.selectedLocationId = nil
                dest.deletedLocation = true
            }
        }
    }

}
