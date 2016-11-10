//
//  ViewController.swift
//  HotCold
//
//  Created by David Alelyunas on 2/6/15.
//  Copyright (c) 2015 David Alelyunas. All rights reserved.
//

import UIKit

import Foundation
import CoreLocation

class ColorViewController: UIViewController, HotColdDelegate {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var warmerOrColder: UILabel!
    
    var startDistance: Double?
    var prevProgress:CGFloat = 0
    
    dynamic var distance: CLLocationDistance = 0
    
    var endLocation: CLLocation?
    var startLocation: CLLocation? {
        didSet {
            startDistance = endLocation!.distance(from: startLocation!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.backgroundColor = UIColor.blue
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showWebpage(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: {(b) in self.dismiss(animated: true, completion: nil)})
    }
    
    func locationChanged(model: HotColdModel) {
        warmerOrColder.text = model.directiveText()
        if let color = model.backgroundColor() {
            colorView.backgroundColor = color
        }
    }
    
    func gameFinished(model: HotColdModel) {
        let alert = UIAlertController(title: "You Have Arrived!", message: "This is " + model.destinationName(), preferredStyle: UIAlertControllerStyle.alert)
        //alert.title = "You Have Arrived!"
        print("name: \(model.destinationName())")
        print("link: \(model.destinationUrl())")
        //alert.message = "This is " + model.destinationName()
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: {(action) in self.dismiss(animated: true, completion: nil)}))
        alert.addAction(UIAlertAction(title: "View", style: UIAlertActionStyle.default, handler: {(action) in self.showWebpage(url: model.destinationUrl())}))
        present(alert, animated: true, completion: nil)

    }
    
    func gameFailedToStart(model: HotColdModel) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gameStarted(model: HotColdModel) {
        
    }
}

