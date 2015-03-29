//
//  MainViewController.swift
//  HotCold
//
//  Created by Jack Frysinger on 2/7/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {
    
    var curLat:Double = 0
    var curLong:Double = 0
    var newLong:Double = 0
    var newLat:Double = 0

    @IBOutlet weak var logoImageVIew: UIImageView!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var myPickerView: UIPickerView!
    @IBOutlet weak var goButtonOutlet: UIButton!
    
    var locationManager:CLLocationManager!
    
    var placeTypeOptions = ["Restaurants", "Historical Landmarks", "Museums", "Parks"] //, "Geocaches"]
    var placeTypeRequest = ["restaurant", "history", "museum", "park", "geocache"]
    var radiusOptions = [0.1, 0.5, 1.0, 5.0, 10.0, 25.0, 50.0]
    
    var lastSelectedPickerViewButton = UIButton()
    
    var placeTypeIndex = 0
    var radiusIndex = 0
    
    @IBAction func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        self.lastSelectedPickerViewButton = UIButton()
        self.updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        //println("locations = \(locations)")
        curLat = manager.location.coordinate.latitude
        curLong = manager.location.coordinate.longitude
    }
    
    func updateUI() {
        self.placeTypeLabel.text = "I want \(self.placeTypeOptions[self.placeTypeIndex].lowercaseString)"
        self.radiusLabel.text = "within \(self.radiusOptions[self.radiusIndex]) miles"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let url = NSURL(string: "http://hc.milodavis.com/getLocation.php?locType=\(placeTypeRequest[placeTypeIndex])&userLat=\(self.curLat)&userLong=\(self.curLong)&radius=\(radiusOptions[radiusIndex])")
        
        var request: NSURLRequest = NSURLRequest(URL: url!)
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil)
        
        let json = JSON(data: data!)
        
        /*if (json == nil) {
            println("JSON was nil")
            var alert = UIAlertView()
            alert.title = "There are no locations that match your criteria!"
            alert.message = "Change your parameters and try again."
            alert.show()
            return;
        }*/
        
        let alat = json["latitude"].doubleValue
        let along = json["longitude"].doubleValue
        let name = json["name"].stringValue
        let link = json["link"].stringValue
        
        let vc = segue.destinationViewController as ColorViewController
        vc.endLocation = CLLocation(latitude: alat, longitude: along)
        vc.startLocation = CLLocation(latitude: self.curLat, longitude: self.curLong)
        vc.name = name
        vc.link = link
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return self.placeTypeOptions.count
        case 1: return self.radiusOptions.count
        default: return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch component {
        case 0: return self.placeTypeOptions[row]
        case 1: return "\(self.radiusOptions[row])"
        default: return "0"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0: self.placeTypeIndex = row
        case 1: self.radiusIndex = row
        default: break
        }
        self.updateUI()
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0: return pickerView.frame.size.width * 0.8
        case 1: return pickerView.frame.size.width * 0.2
        default: return 0
        }
    }
    
    func setIndex(index: Int) {
        if (self.lastSelectedPickerViewButton.currentTitle == "Finding:") {
            self.placeTypeIndex = index
        } else {
            self.radiusIndex = index
        }
        self.updateUI()
    }
}
