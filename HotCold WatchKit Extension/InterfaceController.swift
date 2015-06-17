//
//  InterfaceController.swift
//  HotCold WatchKit Extension
//
//  Created by Jack Frysinger on 6/15/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        outputLabel.setText(SharedLocation.sharedInstance.warmerOrColder?.text)
        group.setBackgroundColor(SharedLocation.sharedInstance.colorView?.backgroundColor)
        print("got here")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBOutlet var group: WKInterfaceGroup!
    @IBOutlet var outputLabel: WKInterfaceLabel!
}
