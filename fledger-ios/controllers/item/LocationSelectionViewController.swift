//
//  ItemlocationEditController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit
import MapKit

class LocationSelectionViewController: AppUIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var sortByLabel: UIBarButtonItem!
    @IBOutlet var table: LocationsTableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    var locationId: Int64?
    var selectHandler: SelectIdHandler?
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        navigationItem.titleView = activity
        
        sortByLabel.title = "Sort By " + LocationSortBy.Name.rawValue
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        table.selectHandler = { id in
            self.selectHandler?(id)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationId.map { table.setLocation($0) }
        table.reloadData()
        deleteButton.enabled = locationId != nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dest = segue.destinationViewController as? LocationEditViewController {
            dest.editHandler = { locationId in
                self.locationId = locationId
                self.navigationController?.popViewControllerAnimated(true)
                self.table.selectHandler.map { handler in locationId.map { handler($0) } }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations userLocations: [AnyObject]!) {
        (userLocations[0] as? CLLocation).map { table.setUserLocation($0) }
        navigationItem.titleView = nil
        locationManager.stopUpdatingLocation()
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
        sortByLabel.title = "Sort By " + table.sortBy.rawValue
        switch table.sortBy {
        case .Distance: table.sortBy = .Name
        case .Name: table.sortBy = .Distance
        }
        table.reloadData()
    }

}
