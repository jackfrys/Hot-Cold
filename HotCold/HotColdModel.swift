//
//  HotColdModel.swift
//  HotCold
//
//  Created by Jack Frysinger on 11/10/16.
//  Copyright © 2016 Jack Frysinger. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit
import CoreLocation

class HotColdModel : NSObject, CLLocationManagerDelegate {
    
    var game: Game?
    let location = SharedLocation.sharedLocation
    var delegate : HotColdDelegate?
    
    private let placeTypeRequest = ["restaurant", "history", "museum", "park", "geocache"]
    private let placeTypeNames = ["Restaurants", "Historical Landmarks", "Museums", "Parks"]
    
    override init() {
        super.init()
        location.delegate = self
    }
    
    func backgroundColor() -> UIColor? {
        return game?.backgroundColor()
    }
    
    func destinationUrl() -> URL {
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
        return placeTypeRequest.count
    }
    
    func startGame(forCategoryAtIndex: Int, radius: Double, withDelegate: HotColdDelegate) {
        self.delegate = withDelegate
        self.sendApiCall(placeTypeIndex: forCategoryAtIndex, radius: radius)
    }
    
    func terminateGame() {
        self.game = nil
    }
    
    func sendApiCall(placeTypeIndex: Int, radius: Double) {
        let components = NSURLComponents(string: "https://nz5bypr9rk.execute-api.us-east-1.amazonaws.com/prod/LambdaFunctionOverHttps/")
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "locType", value: placeTypeRequest[placeTypeIndex]))
        queryItems.append(URLQueryItem(name: "userLat", value: String(describing: (location.locationManager.location?.coordinate.latitude)!)))
        queryItems.append(URLQueryItem(name: "userLong", value: String(describing: (location.locationManager.location?.coordinate.longitude)!)))
        queryItems.append(URLQueryItem(name: "radius", value: String(describing: radius)))

        components?.queryItems = queryItems

        let d = URLSession.shared.dataTask(with: (components?.url)!, completionHandler: {(data, r, error) in self.handleResponse(data: data)})
        d.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationChanged(model: self)
        
        if let finished = game?.gameFinished() {
            if finished {
                delegate?.gameFinished(model: self)
            }
        }
    }
    
    func handleResponse(data: Data?) {
        if let dta = data {
            let json = JSON(data: dta)
            
            let alat = json["latitude"].double!
            let along = json["longitude"].double!
            let name = json["name"].stringValue
            let link = json["link"].stringValue
            
            self.game = Game(start: location.locationManager.location!, end: CLLocation(latitude: alat, longitude: along), name: name, url: link)
            delegate?.gameStarted(model: self)
        } else {
            delegate?.gameFailedToStart(model: self)
        }
    }
    
    class Game {
        let start : CLLocation
        let end : CLLocation
        let name : String
        let url : String
        
        var prevProgress : CGFloat
        
        init(start: CLLocation, end: CLLocation, name: String, url: String) {
            self.start = start
            self.end = end
            self.name = name
            self.url = url
            
            print(end.coordinate.latitude)
            print(end.coordinate.longitude)
            
            self.prevProgress = 0
        }
        
        func ratio() -> CGFloat {
            let top = Double(end.distance(from: currentLocation()))
            let bottom = Double(start.distance(from: end))
            
            return CGFloat(top / bottom)
        }
        
        func backgroundColor() -> UIColor {
            let ratio = self.ratio()
            
            // RGB COLOR INTERPOLATION
            let red:CGFloat = 0
            let green:CGFloat = 0
            let blue:CGFloat = 1.0
            
            let middleRed:CGFloat = 1.0
            let middleGreen:CGFloat = 1.0
            let middleBlue:CGFloat = 1.0
            
            let finalRed:CGFloat = 1.0
            let finalGreen:CGFloat = 0
            let finalBlue:CGFloat = 0
            
            let myProgress : CGFloat = (1.0 - ratio)
            
            if (myProgress <= 0.5) {
                let newRed:CGFloat = middleRed * myProgress * 2.0 + red * (0.5 - myProgress) * 2.0
                let newGreen:CGFloat = middleGreen * myProgress * 2.0 + green * (0.5 - myProgress) * 2.0
                let newBlue:CGFloat = middleBlue * myProgress * 2.0 + blue * (0.5 - myProgress) * 2.0
                
                return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
            }
            else {
                let newRed:CGFloat = finalRed * (myProgress - 0.5) * 2.0 + middleRed * (1.0 - myProgress) * 2.0
                let newGreen:CGFloat = finalGreen * (myProgress - 0.5) * 2.0 + middleGreen * (1.0 - myProgress) * 2.0
                let newBlue:CGFloat = finalBlue * (myProgress - 0.5) * 2.0 + middleBlue * (1.0 - myProgress) * 2.0
                
                return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
            }
        }
        
        func destinationUrl() -> URL {
            return URL(string: self.url)!
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
        
        func currentLocation() -> CLLocation {
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

protocol HotColdDelegate {
    func locationChanged(model: HotColdModel)
    
    func gameStarted(model: HotColdModel)
    
    func gameFailedToStart(model: HotColdModel)
    
    func gameFinished(model: HotColdModel)
}
