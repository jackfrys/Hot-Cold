//
//  ViewController.swift
//  HotCold
//
//  Created by Jack Frysinger on 2/6/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import UIKit
import Foundation

class ColorViewController: UIViewController {
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorSlider: UISlider!
    
    private var myContext = 0
    
    var startDistance: Double = 0
    var isFirstDistance: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set background to blue
        colorView.backgroundColor = UIColor.blueColor()
        
        // Add observer to distance value of sharedInstance
        sharedInstance.addObserver(self, forKeyPath: "distance", options: .New, context: &myContext)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
         println("\(sharedInstance.distance)")
    }
    
    // Called when the sharedInstance.distance value changes
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        if context == &myContext {
            if(isFirstDistance) {
                startDistance = sharedInstance.distance
                isFirstDistance = false
            }
            println("Start: \(startDistance)")
            println("Current: \(sharedInstance.distance)")
            println("Ratio: \(sharedInstance.distance / startDistance)")
            
            colorView.backgroundColor = progressColor(CGFloat(sharedInstance.distance / startDistance))
        }
    }
    
    func progressColor(progress: CGFloat) -> UIColor {
        /* HSB COLOR INTERPOLATION
        var startHue:CGFloat = 0.7
        var startSat:CGFloat = 0.9
        var startBright:CGFloat = 0.9

        var endHue:CGFloat = 1.0
        var endSat:CGFloat = 0.9
        var endBright:CGFloat = 0.9

        var curHue:CGFloat = startHue + (endHue - startHue) * progress
        var curSat:CGFloat = startSat + (endSat - startSat) * progress
        var curBright:CGFloat = startBright + (endBright - startBright) * progress

        return UIColor(hue: curHue, saturation: curSat, brightness: curBright, alpha: 1.0) */

        // RGB COLOR INTERPOLATION
        var red:CGFloat = 0
        var green:CGFloat = 0
        var blue:CGFloat = 1.0

        var finalRed:CGFloat = 1.0
        var finalGreen:CGFloat = 0
        var finalBlue:CGFloat = 0
        
        var myProgress:CGFloat = (1.0 - progress)
        println("progress \(myProgress)")
        
        var newRed:CGFloat   = (1.0 - myProgress) * red   + myProgress * finalRed
        var newGreen:CGFloat  = (1.0 - myProgress) * green + myProgress * finalGreen
        var newBlue:CGFloat   = (1.0 - myProgress) * blue  + myProgress * finalBlue
        var color = UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        
        return color
    }
}

