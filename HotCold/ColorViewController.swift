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
    
    func changeColor(currentColor: UIColor, posDirection:Bool ) -> UIColor {
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        currentColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        var curRed: CGFloat = r * CGFloat(255.0)
        var curGreen: CGFloat = g * CGFloat(255.0)
        var curBlue: CGFloat = b * CGFloat(255.0)

        
        if (posDirection) {
            if (curBlue == 255.0 && curRed < 255.0) {
                return UIColor(red: (curRed + 1.0) / 255.0, green: curGreen, blue: curBlue, alpha: a)
            }
            else if (curBlue > 0) {
                return UIColor(red: curRed, green: curGreen, blue: (curBlue - 1.0) / 255.0, alpha: a)
            }
            else {
                return currentColor
            }
            
        }
        else {
            if(curRed == 255.0 && curBlue < 255.0) {
                return UIColor(red: curRed, green: curGreen, blue: (curBlue + 1.0) / 255.0, alpha: a)
            }
            else if (curRed > 0) {
                return UIColor(red: (curRed - 1.0) / 255.0, green: curGreen, blue: curBlue, alpha: a)
            }
            else {
                return currentColor
            }
            
        }
    }
    
    func changeBlue(direction: Bool) {
        
    }
    
    func changeRed(direction: Bool) {
        colorView.backgroundColor = UIColor.redColor()
    }
    
    
}

