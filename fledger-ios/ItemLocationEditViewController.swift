//
//  ItemDateEditViewController.swift
//  fledger-ios
//
//  Created by Robert Conrad on 4/11/15.
//  Copyright (c) 2015 TwoSpec Inc. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

class ItemLocationEditViewController: CenterPinMapViewController, CenterPinMapViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationLoading: UIActivityIndicatorView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationId: Int64?
    
    var coordinate: CLLocationCoordinate2D?
    
    lazy private var locationManager = CLLocationManager()

    private var userInteractionStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUIViewController.applyStyle(self)
        
        locationLoading.startAnimating()
        locationLoading.hidden = true
        
        shouldReverseGeocode = true
        delegate = self
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        
        userInteractionStarted = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let id = locationId {
            coordinate = ModelServices.location.withId(id)!.coordinate
        }
        
        resetAddress()
        
        if coordinate == nil {
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
            }
        }
        else {
            centerMap()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func centerPinMapViewController(sender: CenterPinMapViewController!, didChangeSelectedCoordinate coordinate: CLLocationCoordinate2D) {
        if userInteractionStarted {
            resetAddress()
            self.coordinate = coordinate
        }
    }
    
    func centerPinMapViewController(sender: CenterPinMapViewController!, didResolvePlacemark p: CLPlacemark!) {
        locationLoading.hidden = true
        locationLabel.text = ABCreateStringWithAddressDictionary(p.addressDictionary, true)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if !userInteractionStarted {
            coordinate = (locations[0] as! CLLocation).coordinate
            centerMap()
        }
        else {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func resetAddress() {
        locationLoading.hidden = false
    }
    
    func centerMap() {
        if let c = coordinate {
            let delta = 0.015
            let span = MKCoordinateSpanMake(delta, delta)
            let region = MKCoordinateRegion(center: c, span: span)
            mapView.setRegion(region, animated: false)
        }
    }
    
}