//
//  ViewController.swift
//  HotCold
//
//  Created by Jack Frysinger on 2/6/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let locationOptions = [0.5, 1.0, 5.0, 10.0, 25.0, 50.0]
    var selectedRadius = 0.0
    
    @IBOutlet weak var selectRadiusButton: UIButton!
    
    @IBAction func startButton() {
        
    }
    
    @IBAction func selectRadius(sender: UIButton) {
        self.pickerView.hidden = !self.pickerView.hidden
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedRadius = self.locationOptions[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI() {
        self.selectRadiusButton.setTitle("\(self.selectedRadius)", forState: UIControlState.Normal)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.locationOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return "\(self.locationOptions[row])"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedRadius = locationOptions[row]
        self.updateUI()
    }
}

