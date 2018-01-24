//
//  HotColdModel.swift
//  HotCold
//
//  Created by Jack Frysinger on 11/10/16.
//  Copyright © 2016 Jack Frysinger. All rights reserved.
//

import Foundation
import SwiftyBeaver
import CoreLocation
import MapKit
import UIKit

class HotColdModel : NSObject, CLLocationManagerDelegate {
    
    private var game: Game?
    private let location = SharedLocation.sharedLocation
    private weak var delegate : HotColdDelegate?
    
    private let placeTypeRequest = ["restaurant", "history", "museum", "park", "geocache"]
    private let placeTypeNames = ["Restaurants", "Historical Landmarks", "Museums", "Parks"]
    
    private let log = SwiftyBeaver.self
    
    override init() {
        super.init()
        location.delegate = self
    }
    
    var locationEnabled : Bool {
        get {
            if let _ = location.location() {
                return true
            }
            return false
        }
    }
    
    func backgroundColor(progress: CGFloat?) -> (CGFloat, CGFloat, CGFloat)? {
        if let p = progress {
            return Game(start: CLLocation(latitude: CLLocationDegrees(0), longitude: CLLocationDegrees(0)), end: CLLocation(latitude: CLLocationDegrees(0), longitude: CLLocationDegrees(0)), name: "hi", url: nil).backgroundColor(progress: p)
        }
        return game?.backgroundColor(progress: progress)
    }
    
    func destinationUrl() -> URL? {
        return game!.destinationUrl()
    }
    
    func destinationName() -> String {
        return game!.destinationName()
    }
    
    func directiveText() -> String? {
        return game?.directiveText()
    }
    
    func placeType(atIndex: Int) -> String {
        return placeTypeNames[atIndex]
    }
    
    func placeTypeCount() -> Int {
        return placeTypeNames.count
    }
    
    func startGame(forCategoryAtIndex: Int, radius: Double, withDelegate: HotColdDelegate) {
        self.delegate = withDelegate
        self.performLocalSearch(placeTypeIndex: forCategoryAtIndex, radius: radius)
    }
    
    func terminateGame() {
        self.game = nil
        self.delegate = nil
        log.debug("Game terminated.")
    }
    
    private func performLocalSearch(placeTypeIndex: Int, radius: Double) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = placeTypeRequest[placeTypeIndex]
        request.region = MKCoordinateRegionMakeWithDistance((location.locationManager.location?.coordinate)!, 2 * radius * 1609.34, 2 * radius * 1609.34)
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            guard let r = response, r.mapItems.count > 0 else {
                self.delegate?.gameFailedToStart(model: self)
                return
            }
            
            self.log.debug(r.mapItems.count)
            for place in r.mapItems {
                let d = place.placemark.location!.distance(from: self.location.locationManager.location!)
                self.log.debug(d)
                if d < radius * 1609.34 {
                    let lat = place.placemark.coordinate.latitude
                    let long = place.placemark.coordinate.longitude
                    let name = place.name!
                    let url = place.url
                    
                    self.game = Game(start: self.location.locationManager.location!, end: CLLocation(latitude: lat, longitude: long), name: name, url: url)
                    self.log.debug("Game started.")
                    self.delegate?.gameStarted(model: self)
                    
                    return
                }
            }
            
            self.delegate?.noResults(model: self)
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        log.debug("Location changed.")
        delegate?.locationChanged(model: self)
        
        if let finished = game?.gameFinished() {
            if finished {
                log.debug("Game finished.")
                delegate?.gameFinished(model: self)
            }
        }
    }
    
    private class Game {
        private let start : CLLocation
        private let end : CLLocation
        private let name : String
        private let url : URL?
        
        private var prevProgress : CGFloat
        
        private let log = SwiftyBeaver.self
        
        init(start: CLLocation, end: CLLocation, name: String, url: URL?) {
            self.start = start
            self.end = end
            self.name = name
            self.url = url
            
            log.info(end.coordinate.latitude)
            log.info(end.coordinate.longitude)
            
            self.prevProgress = 0
        }
        
        private func ratio() -> CGFloat {
            let top = Double(end.distance(from: currentLocation()))
            log.debug("Distance to goal: " + String(top))
            let bottom = Double(start.distance(from: end))
            
            return CGFloat(top / bottom)
        }
        
        func backgroundColor(progress: CGFloat?) -> (CGFloat, CGFloat, CGFloat) {
            let red:CGFloat = 0.1
            let green:CGFloat = 0.3
            let blue:CGFloat = 0.9
            
            let middleRed:CGFloat = 1.0
            let middleGreen:CGFloat = 1.0
            let middleBlue:CGFloat = 1.0
            
            let finalRed:CGFloat = 1.0
            let finalGreen:CGFloat = 0.2
            let finalBlue:CGFloat = 0.0
            
            var myProgress : CGFloat = (1.0 - self.ratio())
            
            if let p = progress {
                myProgress = p
            }
            
            if (myProgress <= 0.5) {
                let newRed:CGFloat = middleRed * myProgress * 2.0 + red * (0.5 - myProgress) * 2.0
                let newGreen:CGFloat = middleGreen * myProgress * 2.0 + green * (0.5 - myProgress) * 2.0
                let newBlue:CGFloat = middleBlue * myProgress * 2.0 + blue * (0.5 - myProgress) * 2.0
                
                return (newRed, newGreen, newBlue)
            }
            else {
                let newRed:CGFloat = finalRed * (myProgress - 0.5) * 2.0 + middleRed * (1.0 - myProgress) * 2.0
                let newGreen:CGFloat = finalGreen * (myProgress - 0.5) * 2.0 + middleGreen * (1.0 - myProgress) * 2.0
                let newBlue:CGFloat = finalBlue * (myProgress - 0.5) * 2.0 + middleBlue * (1.0 - myProgress) * 2.0
                
                return (newRed, newGreen, newBlue)
            }
        }
        
        func destinationUrl() -> URL? {
            return self.url
        }
        
        func directiveText() -> String {
            let myProgress:CGFloat = (1.0 - ratio())
            
            var text : String
            if (prevProgress < myProgress) {
                text = "Warmer"
            } else {
                text = "Colder"
            }
            
            prevProgress = myProgress
            return text
        }
        
        private func currentLocation() -> CLLocation {
            return SharedLocation.sharedLocation.location()!
        }
        
        func destinationName() -> String {
            return name
        }
        
        func gameFinished() -> Bool {
            return currentLocation().distance(from: end) < 10
        }
    }
}

protocol HotColdDelegate : class {
    func locationChanged(model: HotColdModel)
    
    func gameStarted(model: HotColdModel)
    
    func gameFailedToStart(model: HotColdModel)
    
    func gameFinished(model: HotColdModel)
    
    func noResults(model: HotColdModel)
}
