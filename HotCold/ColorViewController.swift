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
import SwiftyBeaver

class ColorViewController: UIViewController, HotColdDelegate {
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var warmerOrColder: UILabel!
    
    let log = SwiftyBeaver.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.backgroundColor = UIColor.blue
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showWebpage(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: {(b) in self.dismiss(animated: true, completion: nil)})
    }
    
    func locationChanged(model: HotColdModel) {
        updateUI(model: model)
    }
    
    private func updateUI(model: HotColdModel) {
        performSelector(onMainThread: #selector(self.updateUIPrivate), with: model, waitUntilDone: false)
    }
    
    private func backgroundColor(rgb: (CGFloat, CGFloat, CGFloat)) -> UIColor {
        return UIColor(red: rgb.0, green: rgb.1, blue: rgb.2, alpha: 1.0)
    }
    
    func gameFinished(model: HotColdModel) {
        let alert = UIAlertController(title: "You Have Arrived!", message: "This is " + model.destinationName(), preferredStyle: UIAlertControllerStyle.alert)
        log.debug("name: \(model.destinationName())")
        log.debug("link: \(model.destinationUrl())")
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: {(action) in self.dismiss(animated: true, completion: nil)}))
        if let destUrl = model.destinationUrl() {
            alert.addAction(UIAlertAction(title: "View", style: UIAlertActionStyle.default, handler: {(action) in self.showWebpage(url: destUrl)}))
        }
        present(alert, animated: true, completion: nil)

    }
    
    func gameFailedToStart(model: HotColdModel) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func gameStarted(model: HotColdModel) {
        updateUI(model: model)
        log.debug("Game started.")
    }
    
    @objc private func updateUIPrivate(model: HotColdModel) {
        log.debug("Updating UI.")
        if let text = model.directiveText() {
            log.debug("Directive text exists: " + text)
            warmerOrColder.text = text
        } else {
            warmerOrColder.text = "loading..."
        }
        if let color = model.backgroundColor() {
            colorView.backgroundColor = backgroundColor(rgb: color)
        }
    }
    
    func noResults(model: HotColdModel) {
        let alert = UIAlertController(title: "No Results", message: "Please adjust your search terms and try again.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: {(action) in self.dismiss(animated: true, completion: nil)}))
        present(alert, animated: true, completion: nil)
    }
}

