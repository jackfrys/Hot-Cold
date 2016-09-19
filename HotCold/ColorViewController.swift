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
        
        
        println(startLocation)
        println(endLocation)
        
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
    
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        
        distance = (manager.location?.distance(from: endLocation))!
        println("INCREMENTED: \(distance)")
        if(distance < self.arrivedDistance && !hasAlerted) {
            var alert = UIAlertView()
            alert.title = "You Have Arrived!"
            println("name: \(name)")
            println("link: \(link)")
            alert.message = "This is " + name
            alert.addButton(withTitle: "Dismiss")
            alert.show()
            hasAlerted = true
        }
    }
    
    // Called when the sharedInstance.distance value changes
    override func observeValue(forKeyPath keyPath: String, of object: AnyObject, change: [AnyHashable: Any], context: UnsafeMutableRawPointer) {
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
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 1.0
        
        var middleRed:CGFloat = 1.0
        var middleGreen:CGFloat = 1.0
        var middleBlue:CGFloat = 1.0
        
        var finalRed:CGFloat = 1.0
        var finalGreen:CGFloat = 0
        var finalBlue:CGFloat = 0
        
        println("previous: \(prevProgress)")
        var myProgress:CGFloat = (1.0 - ratio)
        println("progress: \(myProgress)")
        
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
            var newRed:CGFloat   = middleRed * myProgress * 2.0 + red * (0.5 - myProgress) * 2.0
            var newGreen:CGFloat  = middleGreen * myProgress * 2.0 + green * (0.5 - myProgress) * 2.0
            var newBlue:CGFloat   = middleBlue * myProgress * 2.0 + blue * (0.5 - myProgress) * 2.0
            
            return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        }
        else {
            var newRed:CGFloat = finalRed * (myProgress - 0.5) * 2.0 + middleRed * (1.0 - myProgress) * 2.0
            var newGreen:CGFloat = finalGreen * (myProgress - 0.5) * 2.0 + middleGreen * (1.0 - myProgress) * 2.0
            var newBlue:CGFloat = finalBlue * (myProgress - 0.5) * 2.0 + middleBlue * (1.0 - myProgress) * 2.0
            
            return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        }
    }
}

