//
//  SharedLocation.swift
//  LocationPuzzleGame
//
//  Created by Charlie Peters on 1/25/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//
// http://hc.milodavis.com/getLocation.php

import Foundation
import CoreLocation
import UIKit

class SharedLocation: NSObject, CLLocationManagerDelegate {
    class var sharedInstance: SharedLocation {
        struct Static {
            static var instance: SharedLocation?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = SharedLocation()
        }
        
        return Static.instance!
    }
    
    var locationManager = CLLocationManager()
    
    // You can access the lat and long by calling:
    // currentLocation2d.latitude, etc
    var currentLocation2d: CLLocationCoordinate2D?
    
    // You can access the absolute distance to the goal
    dynamic var distance: CLLocationDistance
    
    // NOTE TO MILO, Change this if you are testing dummy locations
    // Closest Chipotle: lat 42.362428, long -71.085611
    let dummyLocationCoord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(42.362428, -71.085611)
    let dummyLocation: CLLocation
    
    override init() {
        self.locationManager.distanceFilter  = 50
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.startUpdatingLocation()
        println("before")
        self.locationManager.requestAlwaysAuthorization()
        println("after")
        self.dummyLocation = CLLocation(latitude: dummyLocationCoord.latitude, longitude: dummyLocationCoord.longitude)
        self.distance = 0.0
        super.init()
        self.locationManager.delegate = self
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            println(".NotDetermined")
            break
            
        case .Authorized:
            println(".Authorized")
            self.locationManager.startUpdatingLocation()
            break
            
        case .Denied:
            println(".Denied")
            break
            
        default:
            println("Unhandled authorization status")
            break
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.currentLocation2d = manager.location.coordinate
        distance = manager.location.distanceFromLocation(dummyLocation)
        
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        
        var alert = UIAlertView()
        alert.title = "New Secure Communication:"
        alert.message = "You have arrived"
        alert.addButtonWithTitle("Later")
        alert.addButtonWithTitle("View")
        alert.show()
        
    }
    
}

let sharedInstance = SharedLocation()