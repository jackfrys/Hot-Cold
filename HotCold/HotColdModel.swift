//
//  HotColdModel.swift
//  HotCold
//
//  Created by Jack Frysinger on 11/10/16.
//  Copyright © 2016 Jack Frysinger. All rights reserved.
//

import Foundation
import UIKit

class HotColdModel {
    
    func backgroundColor() -> UIColor {
        return UIColor()
    }
    
    func destinationUrl() -> URL {
        return URL(string: "")!
    }
    
    func directiveText() -> String {
        return ""
    }
    
    func placeType(atIndex: Int) -> String {
        return ""
    }
    
    func startGame(forCategoryAtIndex: Int, radius: Double) {
        
    }
}

protocol HotColdDelegate {
    func locationChanged()
    
    func gameStarted()
}
