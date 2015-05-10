//
//  AccountTableView.swift
//  fledger-ios
//
//  Created by Robert Conrad on 5/2/15.
//  Copyright (c) 2015 Robert Conrad. All rights reserved.
//

import UIKit
import MapKit


class LocationsTableView: AppUITableView, UITableViewDataSource, UITableViewDelegate {
    
    private var locationId: Int64?
    private var locations: [Location]?
    private var userLocation: CLLocation?
    private let locationService = Services.get(LocationService.self)
    
    var sortBy = LocationSortBy.Distance
    var selectHandler: SelectIdHandler?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        dataSource = self
    }
    
    func setLocation(id: Int64) {
        self.locationId = id
        selectLocation()
    }
    
    func setUserLocation(location: CLLocation) {
        userLocation = location
        reloadData()
    }
    
    private func selectLocation() {
        let index = locations?.find { $0.id == self.locationId }
        if let i = index {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Middle)
        }
    }
    
    override func reloadData() {
        if let location = userLocation {
            locations = locationService.nearest(location.coordinate, sortBy: sortBy)
            super.reloadData()
            selectLocation()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.map { locations in locations.count } ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = dequeueReusableCellWithIdentifier("default") as! ValueDetailUITableViewCell
        
        if let location = locations?[indexPath.row] {
            cell.textLabel?.text = location.title()
            ValueUITableViewCell.setFieldDistance(cell.value, double: location.distance ?? -1)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let handler = selectHandler, locationId = locations?[indexPath.row].id {
            handler(locationId)
        }
    }

}