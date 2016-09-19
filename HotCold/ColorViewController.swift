//
//  ViewController.swift
//  HotCold
//
//  Created by David Alelyunas on 2/6/15.
//  Copyright (c) 2015 David Alelyunas. All rights reserved.
//

import UIKit

import Foundation
import CoreLocation

class ColorViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var colorView: UIView!
    
    @IBOutlet weak var warmerOrColder: UILabel!
    
    fileprivate var myContext = 0
    
    var startDistance: Double = 0
    var prevProgress:CGFloat = 0
    
    dynamic var distance: CLLocationDistance = 0
    
    var endLocation: CLLocation = CLLocation(latitude:0, longitude:0)
    var startLocation: CLLocation = CLLocation(latitude:0, longitude: 0)
    var name = ""
    var link = ""
    var hasAlerted = false
    
    let arrivedDistance = 20.0
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background to blue
        colorView.backgroundColor = UIColor.blue
        
        
        print(startLocation)
        print(endLocation)
        
        warmerOrColder.isHidden = true
        
        startDistance = endLocation.distance(from: startLocation)
        
        // Add observer to distance value of sharedInstance
        self.addObserver(self, forKeyPath: "distance", options: .new, context: &myContext)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeObserver(self, forKeyPath: "distance")
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
//        
//        distance = (manager.location?.distance(from: endLocation))!
//        print("INCREMENTED: \(distance)")
//        if(distance < self.arrivedDistance && !hasAlerted) {
//            var alert = UIAlertView()
//            alert.title = "You Have Arrived!"
//            print("name: \(name)")
//            print("link: \(link)")
//            alert.message = "This is " + name
//            alert.addButton(withTitle: "Dismiss")
//            alert.show()
//            hasAlerted = true
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        distance = (manager.location?.distance(from: endLocation))!
        print("INCREMENTED: \(distance)")
        if(distance < self.arrivedDistance && !hasAlerted) {
            let alert = UIAlertController(title: "You Have Arrived!", message: "This is " + name, preferredStyle: UIAlertControllerStyle.alert)
            alert.title = "You Have Arrived!"
            print("name: \(name)")
            print("link: \(link)")
            alert.message = "This is " + name
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            alert.show(self, sender: nil)
            hasAlerted = true
        }
    }
    
    // Called when the sharedInstance.distance value changes
    func observeValue(forKeyPath keyPath: String, of object: AnyObject, change: [AnyHashable: Any], context: UnsafeMutableRawPointer) {
        if context == &myContext {
            //println("Start: \(startDistance)")
            //println("Current: \(distance)")
            //println("Ratio: \(distance / startDistance)")
            
            colorView.backgroundColor = progressColor(CGFloat(distance / startDistance))
        }
    }    
    
    //
    func progressColor(_ ratio: CGFloat) -> UIColor {
        // RGB COLOR INTERPOLATION
        let red:CGFloat = 0
        let green:CGFloat = 0
        let blue:CGFloat = 1.0
        
        let middleRed:CGFloat = 1.0
        let middleGreen:CGFloat = 1.0
        let middleBlue:CGFloat = 1.0
        
        let finalRed:CGFloat = 1.0
        let finalGreen:CGFloat = 0
        let finalBlue:CGFloat = 0
        
        print("previous: \(prevProgress)")
        let myProgress:CGFloat = (1.0 - ratio)
        print("progress: \(myProgress)")
        
        if(prevProgress < myProgress) {
            warmerOrColder.text = "Warmer"
            warmerOrColder.isHidden = false
        }
        else if(prevProgress > myProgress) {
            warmerOrColder.text = "Colder"
            warmerOrColder.isHidden = false
            
        }
        else {
            warmerOrColder.isHidden = true
        }
        /*UIView.animateWithDuration(2.0, delay:0, options: .Repeat | .Autoreverse, animations: {
        
        self.warmerOrColder.frame = CGRect(x: 120, y: 220, width: 200, height: 200)
        
        }, completion: nil)*/
        
        prevProgress = myProgress
        
        if(myProgress <= 0.5) {
            let newRed:CGFloat   = middleRed * myProgress * 2.0 + red * (0.5 - myProgress) * 2.0
            let newGreen:CGFloat  = middleGreen * myProgress * 2.0 + green * (0.5 - myProgress) * 2.0
            let newBlue:CGFloat   = middleBlue * myProgress * 2.0 + blue * (0.5 - myProgress) * 2.0
            
            return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        }
        else {
            let newRed:CGFloat = finalRed * (myProgress - 0.5) * 2.0 + middleRed * (1.0 - myProgress) * 2.0
            let newGreen:CGFloat = finalGreen * (myProgress - 0.5) * 2.0 + middleGreen * (1.0 - myProgress) * 2.0
            let newBlue:CGFloat = finalBlue * (myProgress - 0.5) * 2.0 + middleBlue * (1.0 - myProgress) * 2.0
            
            return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        }
    }
}

