//
//  MainViewController.swift
//  HotCold
//
//  Created by Jack Frysinger on 2/7/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import UIKit
import SwiftyBeaver

class MainViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let model = HotColdModel()

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var myPickerView: UIPickerView!
    @IBOutlet weak var goButtonOutlet: UIButton!
    @IBOutlet weak var radiusSlider: UISlider!
    
    let log = SwiftyBeaver.self
    
    private var radius: Double {
        get {
            let x = Double(self.radiusSlider.value)
            return (x < 0.5) ? (4.8*x + 2.4*x*x) : (46.5714*x*x + 24.1429*x - 20.7143)
        }
    }
    
    @IBAction func radiusValueChanged(_ sender: AnyObject) {
        self.updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        model.terminateGame()
    }
    
    private func updateUI() {
        let r = String(format: "%0.1f", self.radius)
        self.descriptionLabel.text = "\(self.model.placeType(atIndex: myPickerView.selectedRow(inComponent: 0)))\nwithin \(r) miles"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if ProcessInfo.processInfo.arguments.contains("-UITesting") {
            return
        }
        
        model.startGame(forCategoryAtIndex: myPickerView.selectedRow(inComponent: 0), radius: radius, withDelegate: segue.destination as! ColorViewController)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if model.locationEnabled || ProcessInfo.processInfo.arguments.contains("-UITesting") {
            return true
        }
        
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: {(action) in self.dismiss(animated: true, completion: nil)}))
        present(alert, animated: true, completion: nil)
        return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.model.placeTypeCount()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.model.placeType(atIndex: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.updateUI()
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width * 0.8
    }
}
