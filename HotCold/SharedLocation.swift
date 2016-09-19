//
//  SharedLocation.swift
//  LocationPuzzleGame
//
//  Created by Charlie Peters on 2/7/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//
// http://hc.milodavis.com/getLocation.php

import Foundation
import CoreLocation
import UIKit

class SharedLocation: NSObject, CLLocationManagerDelegate {
    private static var __once: () = {
            Static.instance = SharedLocation()
        }()
    class var sharedInstance: SharedLocation {
        struct Static {
            static var instance: SharedLocation?
            static var token: Int = 0
        }
        
        _ = SharedLocation.__once
        
        return Static.instance!
    }
    
    var locationManager = CLLocationManager()
    
    // You can access the current lat and long by calling:
    // currentLocation2d.latitude, etc
    var currentLocation2d: CLLocationCoordinate2D?
    
    // You can access the absolute distance to the goal
    dynamic var distance: CLLocationDistance
    
    // NOTE TO MILO, Change this if you are testing dummy locations
    // Closest Chipotle: lat 42.362428, long -71.085611
    let dummyLocationCoord: CLLocationCoordinate2D = CLLocationCoordinate2DMake(42.362428, -71.085611)
    let dummyLocation: CLLocation
    
    override init() {
        // Update every 5 meters
        self.locationManager.distanceFilter  = 5
        // Accurate to 10 meters
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // Start updating location if you already have permission
        self.locationManager.startUpdatingLocation()
        // If you don't have permission, ask nicely (message in plist)!
        println("requesting in init")
        self.locationManager.requestWhenInUseAuthorization()
        // Test Location
        self.dummyLocation = CLLocation(latitude: dummyLocationCoord.latitude, longitude: dummyLocationCoord.longitude)
        self.distance = 100.0
        super.init()
        self.locationManager.delegate = self
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func resumeUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager!, didChangeAuthorization status: CLAuthorizationStatus) {
        println("didChangeAuthorizationStatus")
        
        switch status {
        case .notDetermined:
            println(".NotDetermined")
            break
            
        case .authorizedAlways:
            println(".Authorized")
            self.locationManager.startUpdatingLocation()
            break
            
        case .denied:
            println(".Denied")
            break
            
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            
        default:
            println("Unhandled authorization status")
            break
            
        }
    }
    // If updating locations
    func locationManager(_ manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.currentLocation2d = manager.location?.coordinate
        distance = (manager.location?.distance(from: dummyLocation))!
        if(distance < 10.0) {
            let alert = UIAlertView()
            alert.title = "Congratulations:"
            alert.message = "You have arrived"
            alert.addButton(withTitle: "Later")
            alert.addButton(withTitle: "View")
            alert.show()
        }
        
    }
    
    // Uncomment if you want to use geofencing!
    //    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
    //
    //        var alert = UIAlertView()
    //        alert.title = "New Secure Communication:"
    //        alert.message = "You have arrived"
    //        alert.addButtonWithTitle("Later")
    //        alert.addButtonWithTitle("View")
    //        alert.show()
    //
    //    }
    
}

let sharedInstance = SharedLocation()
