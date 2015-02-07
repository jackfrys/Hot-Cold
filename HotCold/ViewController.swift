//
//  ViewController.swift
//  HotCold
//
//  Created by Jack Frysinger on 2/6/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var locationRadiusSlider: UISlider!
    @IBOutlet weak var locationRadiusDisplay: UILabel!

    @IBAction func sliderUpdated() {
        self.updateDisplay()
    }
    
    @IBAction func startButton() {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateDisplay() {
        self.locationRadiusDisplay.text = "\(self.locationRadiusSlider.value)"
    }

}

