//
//  ViewController.swift
//  HotCold
//
//  Created by Jack Frysinger on 2/6/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {
    @IBOutlet weak var colorView: UIView!
    
    var scale: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.backgroundColor = UIColor.blueColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func determineColorChange(currentColor: UIColor) {
        if currentColor.get
    }
    
    func colder() {
        
    }
    
    func warmer() {
        colorView.backgroundColor = UIColor.redColor()
    }
    
    
}

