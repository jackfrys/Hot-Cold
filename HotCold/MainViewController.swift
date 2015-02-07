//
//  MainViewController.swift
//  HotCold
//
//  Created by Jack Frysinger on 2/7/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var logoImageVIew: UIImageView!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var myPickerView: UIPickerView!
    @IBOutlet weak var goButtonOutlet: UIButton!
    
    var placeTypeOptions = ["Restaurants", "Historical Landmarks", "Museums", "Parks", "Geocaches"]
    var placeTypeRequest = ["restaurant", "history", "museum", "park", "geocache"]
    var radiusOptions = [0.1, 0.5, 1.0, 5.0, 10.0, 25.0, 50.0]
    
    var myPickerViewDataSource = [AnyObject]()
    var lastSelectedPickerViewButton = UIButton()
    
    var placeTypeIndex = 0
    var radiusIndex = 0
    
    
    
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
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let rec = Requests()
        //rec.makeRequest(self.placeTypeRequest[self.placeTypeIndex], radius: self.radiusOptions[self.radiusIndex])
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
