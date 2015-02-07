//
//  ViewController.swift
//  HotCold
//
//  Created by Jack Frysinger on 2/6/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UITextViewDelegate {
    
    var radiusOptions = ["0.5", "1.0", "5.0", "10.0", "25.0", "50.0"]
    var locationOptions = ["History", "Park", "Restaurant", "Museum", "Geocache"]
    
    @IBOutlet var textfieldLocation: UITextField!
    @IBOutlet var textfieldRadius: UITextField!
    
    @IBOutlet var pickerRadius: UIPickerView! = UIPickerView()
    
    @IBOutlet var pickerLocation: UIPickerView! = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfieldLocation.tag = 1
        textfieldRadius.tag = 0
        
        pickerRadius.hidden = true
        pickerRadius.tag = 0
        
        pickerLocation.hidden = true
        pickerLocation.tag = 1
        
        textfieldRadius.text = ""
        textfieldLocation.text = ""
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView.tag == 0) {
        return radiusOptions.count
        }
        else {
            return locationOptions.count
        }
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        if(pickerView.tag == 0) {
        return radiusOptions[row]
        }
        else {
            return locationOptions[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        if(pickerView.tag == 0) {
        textfieldRadius.text = radiusOptions[row]
        pickerRadius.hidden = true
        }
        else {
            textfieldLocation.text = locationOptions[row]
            pickerLocation.hidden = true
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if(textField.tag == 0) {
        pickerLocation.hidden = true
        pickerRadius.hidden = false
        return false
        }
        else {
            pickerRadius.hidden = true
            pickerLocation.hidden = false
            return false
        }
}
}