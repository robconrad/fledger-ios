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


class LocationEditViewController: CenterPinMapViewController, CenterPinMapViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var locationLoading: UIActivityIndicatorView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var name: UITextField!
    
    let model = LocationEditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUIViewController.applyStyle(self)
        model.initializeController(self)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        model.beginInteraction()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        model.initializeMap()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        model.cleanup()
    }
    
    func centerPinMapViewController(sender: CenterPinMapViewController!, didChangeSelectedCoordinate coordinate: CLLocationCoordinate2D) {
        model.updateCoordinateFromMap(coordinate)
    }
    
    func centerPinMapViewController(sender: CenterPinMapViewController!, didResolvePlacemark placemark: CLPlacemark!) {
        model.finishGeocoding(placemark)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        model.updateCoordinateFromLocationManager((locations[0] as! CLLocation).coordinate)
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if let annotation = view.annotation as? LocationAnnotation {
            model.selectAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        model.deselectAnnotation()
    }
    
    @IBAction func saveLocation(sender: AnyObject) {
        
        var locationId: Int64?
        
        if let location = model.getUpdatedLocation() {
            if let id = location.id {
                if ModelServices.location.update(location) {
                    locationId = id
                }
            }
            else {
                locationId = ModelServices.location.insert(location)
            }
        }
        
        if locationId != nil {
            if let nav = navigationController {
                nav.popViewControllerAnimated(true)
                if let dest = nav.viewControllers.last as? LocationSelectionViewController {
                    dest.locationId = locationId
                }
            }
        }
        else {
            
        }
    }
    
}

class LocationEditViewModel {
    
    private var c: LocationEditViewController?
    
    private var locationId: Int64?
    private var location: Location?
    
    private var coordinate: CLLocationCoordinate2D?
    private var address: String?
    private var lastPlacemark: CLPlacemark?
    
    private var selectedAnnotation: LocationAnnotation?
    
    private var userInteractionStarted = false
    
    lazy private var locationManager = CLLocationManager()
    
    func initializeController(c: LocationEditViewController) {
        self.c = c
        
        c.locationLoading.startAnimating()
        c.locationLoading.hidden = true
        c.saveButton.enabled = false
        
        c.shouldReverseGeocode = true
        c.delegate = c
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            for loc in ModelServices.location.all() {
                // ignore our own annotation because it will be added in map initialization synchronously
                if self.locationId != loc.id {
                    self.c!.mapView.addAnnotation(LocationAnnotation(location: loc))
                }
            }
        }
    }
    
    func initializeMap() {
        if let id = locationId {
            location = ModelServices.location.withId(id)
            coordinate = location!.coordinate
            c!.name.text = location!.name ?? ""
        }
        else {
            beginGeocoding()
        }
        
        if coordinate == nil {
            locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = c
                locationManager.startUpdatingLocation()
            }
        }
        else {
            setRegion()
            if let loc = location {
                let a = LocationAnnotation(location: loc)
                self.c!.mapView.addAnnotation(a)
                c!.mapView.selectAnnotation(a, animated: true)
            }
        }
    }
    
    func setLocationId(locationId: Int64?) {
        self.locationId = locationId
    }
    
    func beginInteraction() {
        userInteractionStarted = true
    }
    
    func updateCoordinateFromMap(coordinate: CLLocationCoordinate2D) {
        if userInteractionStarted {
            if let selected = c!.mapView.selectedAnnotations as? [MKPointAnnotation] {
                for a in selected {
                    c!.mapView.deselectAnnotation(a, animated: true)
                }
            }
            beginGeocoding()
            self.coordinate = coordinate
        }
    }
    
    func updateCoordinateFromLocationManager(coordinate: CLLocationCoordinate2D) {
        if userInteractionStarted {
            locationManager.stopUpdatingLocation()
        }
        else {
            self.coordinate = coordinate
            setRegion()
        }
    }
    
    func beginGeocoding() {
        c!.locationLoading.hidden = false
        c!.saveButton.enabled = false
    }
    
    private func finishGeocoding() {
        c!.locationLoading.hidden = true
        c!.saveButton.enabled = true
    }
    
    func finishGeocoding(placemark: CLPlacemark) {
        lastPlacemark = placemark
        if selectedAnnotation == nil {
            finishGeocoding()
            address = ABCreateStringWithAddressDictionary(placemark.addressDictionary, true)
            c!.locationLabel.text = address
        }
    }
    
    func selectAnnotation(annotation: LocationAnnotation) {
        finishGeocoding()
        selectedAnnotation = annotation
        c!.name.text = annotation.location.name
        c!.locationLabel.text = annotation.location.address
        c!.centerAnnotationView.hidden = true
    }
    
    func deselectAnnotation() {
        selectedAnnotation = nil
        if let placemark = lastPlacemark {
            finishGeocoding(placemark)
        }
        c!.centerAnnotationView.hidden = false
        c!.name.text = nil
    }
    
    func getUpdatedLocation() -> Location? {
        if let annotation = selectedAnnotation {
            return annotation.location.copy(name: getName())
        }
        else if coordinate != nil && address != nil {
            return Location(id: locationId, name: getName(), coordinate: coordinate!, address: address!)
        }
        return nil
    }
    
    func cleanup() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.stopUpdatingLocation()
        }
    }
    
    private func getName() -> String? {
        return c!.name.text == "" ? nil : c!.name.text
    }
    
    private func setRegion() {
        if let coord = coordinate {
            let delta = 0.015
            let span = MKCoordinateSpanMake(delta, delta)
            let region = MKCoordinateRegion(center: coord, span: span)
            c!.mapView.setRegion(region, animated: false)
        }
    }
    
}