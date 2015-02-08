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
    
    @IBOutlet var pickerSelectorButtons: [UIButton]!
    
    var locationManager:CLLocationManager!
    
    var placeTypeOptions = ["Restaurants", "Historical Landmarks", "Museums", "Parks"] //, "Geocaches"]
    var placeTypeRequest = ["restaurant", "history", "museum", "park", "geocache"]
    var radiusOptions = [0.1, 0.5, 1.0, 5.0, 10.0, 25.0, 50.0]
    
    var myPickerViewDataSource = [AnyObject]()
    var lastSelectedPickerViewButton = UIButton()
    
    var placeTypeIndex = 0
    var radiusIndex = 0
    
    @IBAction func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        self.myPickerView.hidden = true
        self.lastSelectedPickerViewButton = UIButton()
        self.updateUI()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        
        for button in self.pickerSelectorButtons {
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.blackColor().CGColor
        }
        
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
    
    @IBAction func openPickerView(sender: UIButton) {
        if (sender.currentTitle == "Finding:") {
            self.myPickerViewDataSource = self.placeTypeOptions
        } else {
            self.myPickerViewDataSource = self.radiusOptions
        }
        if (self.lastSelectedPickerViewButton == sender) {
            self.myPickerView.hidden = true
            self.lastSelectedPickerViewButton = UIButton()
        } else {
            self.myPickerView.hidden = false
            self.lastSelectedPickerViewButton = sender
        }
        self.myPickerView.reloadAllComponents()
        self.goButtonOutlet.hidden = !self.myPickerView.hidden
    }
    
    func updateUI() {
        self.placeTypeLabel.text = "\(self.placeTypeOptions[self.placeTypeIndex])"
        self.radiusLabel.text = "Location within: \(self.radiusOptions[self.radiusIndex]) miles"
        self.goButtonOutlet.hidden = !self.myPickerView.hidden
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
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.myPickerViewDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(self.myPickerViewDataSource[row])"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.setIndex(row)
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
