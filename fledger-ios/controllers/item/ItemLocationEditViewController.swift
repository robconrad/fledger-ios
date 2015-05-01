//
//  ItemlocationEditController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit
import MapKit

class ItemLocationEditViewController: AppUIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var sortByLabel: UIBarButtonItem!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var locationId: Int64?
    var locations: [Location]?
    
    private var sortBy = LocationSortBy.Distance
    
    private var userLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        navigationItem.titleView = activity
        
        sortByLabel.title = "Sort By " + LocationSortBy.Name.rawValue
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations userLocations: [AnyObject]!) {
        userLocation = userLocations[0] as? CLLocation
        navigationItem.titleView = nil
        locationManager.stopUpdatingLocation()
        reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        deleteButton.enabled = locationId != nil
        reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.map { locations in locations.count } ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCellWithIdentifier("default") as! ValueDetailUITableViewCell
        
        if let location = locations?[indexPath.row] {
            cell.textLabel?.text = location.title()
            ValueUITableViewCell.setFieldDistance(cell.value, double: location.distance ?? -1)
        }
        
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
    
    @IBAction func sortByAction(sender: AnyObject) {
        sortByLabel.title = "Sort By " + sortBy.rawValue
        switch sortBy {
        case .Distance: sortBy = .Name
        case .Name: sortBy = .Distance
        }
        reloadData()
    }
    
    private func reloadData() {
        if let location = userLocation {
            locations = ModelServices.location.nearest(location.coordinate, sortBy: sortBy)
            table.reloadData()
            
            let index = locations!.find { $0.id == self.locationId }
            if let i = index {
                let indexPath = NSIndexPath(forRow: i, inSection: 0)
                table.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
            }
        }
    }

}
