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
    @IBOutlet weak var colorSlider: UISlider!
    
    var oldSliderValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.backgroundColor = UIColor.blueColor()
        println("\(colorSlider.value)")
        println("\(colorView.backgroundColor)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
       
        colorView.backgroundColor = progressColor(CGFloat(sender.value / 510))
        
        println("\(colorSlider.value)")
        println("\(colorView.backgroundColor)")
    }
    
    func progressColor(progress: CGFloat) -> UIColor {
        //HSB COLOR INTERPOLATION
        /*
        var startHue:CGFloat = 0.7
        var startSat:CGFloat = 0.9
        var startBright:CGFloat = 0.9

        var endHue:CGFloat = 1.0
        var endSat:CGFloat = 0.9
        var endBright:CGFloat = 0.9

        var curHue:CGFloat = startHue + (endHue - startHue) * progress
        var curSat:CGFloat = startSat + (endSat - startSat) * progress
        var curBright:CGFloat = startBright + (endBright - startBright) * progress

        return UIColor(hue: curHue, saturation: curSat, brightness: curBright, alpha: 1.0)
        */

        // RGB COLOR INTERPOLATION 

        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 1.0

        var finalRed:CGFloat = 1.0
        var finalGreen:CGFloat = 0
        var finalBlue:CGFloat = 0
        
        var newRed:CGFloat   = (1.0 - progress) * red   + progress * finalRed
        var newGreen:CGFloat  = (1.0 - progress) * green + progress * finalGreen
        var newBlue:CGFloat   = (1.0 - progress) * blue  + progress * finalBlue
        var color = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        
        return color
        
    }
}

