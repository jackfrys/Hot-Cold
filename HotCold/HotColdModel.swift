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
    
    var game: Game?
    
    func backgroundColor() -> UIColor {
        return game!.backgroundColor()
    }
    
    func destinationUrl() -> URL {
        return game!.destinationUrl()
    }
    
    func directiveText() -> String {
        return game!.directiveText()
    }
    
    func placeType(atIndex: Int) -> String {
        return ["Restaurants", "Historical Landmarks", "Museums", "Parks"][atIndex]
    }
    
    func startGame(forCategoryAtIndex: Int, radius: Double, withDelegate: HotColdDelegate) {
        self.game = Game(forCategoryAtIndex: forCategoryAtIndex, radius: radius, withDelegate: withDelegate)
    }
    
    class Game {
        let category: Int
        let radius: Double
        let delegate: HotColdDelegate
        
        init(forCategoryAtIndex: Int, radius: Double, withDelegate: HotColdDelegate) {
            self.category = forCategoryAtIndex
            self.radius = radius
            self.delegate = withDelegate
        }
        
        func backgroundColor() -> UIColor {
            return UIColor()
        }
        
        func destinationUrl() -> URL {
            return URL(string: "")!
        }
        
        func directiveText() -> String {
            return ""
        }
    }
}

protocol HotColdDelegate {
    func locationChanged()
    
    func gameStarted()
    
    func gameFinished()
}
