//
//  SharedLocation.swift
//  LocationPuzzleGame
//
//  Created by Charlie Peters on 2/7/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyBeaver

class SharedLocation: NSObject, CLLocationManagerDelegate {
    
    static let sharedLocation = SharedLocation()
    
    var locationManager = CLLocationManager()
    
    var delegate : CLLocationManagerDelegate? {
        didSet {
            locationManager.delegate = delegate
        }
    }
        
    private override init() {
        // Update every 5 meters
        self.locationManager.distanceFilter  = 5
        
        // Accurate to 10 meters
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        // Start updating location if you already have permission
        self.locationManager.startUpdatingLocation()
        
        // If you don't have permission, ask nicely (message in plist)!
        self.locationManager.requestWhenInUseAuthorization()

        super.init()
        self.locationManager.delegate = self
    }
    
    func location() -> CLLocation? {
        return locationManager.location
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func resumeUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        switch status {
        case .notDetermined:
            print(".NotDetermined")
            break
        case .authorizedAlways:
            print(".Authorized")
            self.locationManager.startUpdatingLocation()
            break
        case .denied:
            print(".Denied")
            break
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            break
        default:
            print("Unhandled authorization status")
            break
        }
    }
}
