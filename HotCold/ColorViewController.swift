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
    
    var startDistance: Double?
    var prevProgress:CGFloat = 0
    
    dynamic var distance: CLLocationDistance = 0
    
    var endLocation: CLLocation?
    var startLocation: CLLocation? {
        didSet {
            startDistance = endLocation!.distance(from: startLocation!)
        }
    }
    var name = ""
    var link = ""
    var hasAlerted = false
    
    let arrivedDistance = 20.0
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorView.backgroundColor = UIColor.blue
        
        warmerOrColder.isHidden = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let e = endLocation, let s = startDistance {
            distance = (manager.location?.distance(from: e))!
            print("INCREMENTED: \(distance)")
            if(distance < self.arrivedDistance && !hasAlerted) {
                let alert = UIAlertController(title: "You Have Arrived!", message: "This is " + name, preferredStyle: UIAlertControllerStyle.alert)
                alert.title = "You Have Arrived!"
                print("name: \(name)")
                print("link: \(link)")
                alert.message = "This is " + name
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: {(action) in self.dismiss(animated: true, completion: nil)}))
                alert.addAction(UIAlertAction(title: "View", style: UIAlertActionStyle.default, handler: {(action) in self.showWebpage()}))
                present(alert, animated: true, completion: nil)
                hasAlerted = true
            }
            colorView.backgroundColor = progressColor(CGFloat(distance / s))
        }
    }
    
    func showWebpage() {
        let url = URL(string: link)!
        UIApplication.shared.open(url, options: [:], completionHandler: {(b) in self.dismiss(animated: true, completion: nil)})
    }
    
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
        
        if (prevProgress < myProgress) {
            warmerOrColder.text = "Warmer"
            warmerOrColder.isHidden = false
        } else if (prevProgress > myProgress) {
            warmerOrColder.text = "Colder"
            warmerOrColder.isHidden = false
            
        } else {
            warmerOrColder.isHidden = true
        }
        
        prevProgress = myProgress
        
        if (myProgress <= 0.5) {
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

