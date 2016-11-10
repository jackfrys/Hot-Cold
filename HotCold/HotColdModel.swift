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

class HotColdModel {
    
    var game: Game?
    let location = SharedLocation.sharedLocation
    var delegate : HotColdDelegate?
    
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
    
    func placeTypeCount() -> Int {
        return 4
    }
    
    func startGame(forCategoryAtIndex: Int, radius: Double, withDelegate: HotColdDelegate) {
        self.delegate = withDelegate
        self.sendApiCall(placeTypeIndex: forCategoryAtIndex, radius: radius)
    }
    
    func sendApiCall(placeTypeIndex: Int, radius: Double) {
        let url = URL(string: "https://nz5bypr9rk.execute-api.us-east-1.amazonaws.com/prod/LambdaFunctionOverHttps/?locType=\(placeType(atIndex: placeTypeIndex))&userLat=\((location.locationManager.location?.coordinate.latitude)!)&userLong=\((location.locationManager.location?.coordinate.longitude)!)&radius=\(radius)")
        
        let d = URLSession.shared.dataTask(with: url!, completionHandler: {(data, r, error) in self.handleResponse(data: data)})
        d.resume()
    }
    
    func handleResponse(data: Data?) {
        if let dta = data {
            let json = JSON(data: dta)
            
            let alat = json["latitude"].double!
            let along = json["longitude"].double!
            let name = json["name"].stringValue
            let link = json["link"].stringValue
            
            self.game = Game(start: location.locationManager.location!, end: CLLocation(latitude: alat, longitude: along), name: name, url: link)
            delegate?.gameStarted()
        } else {
            delegate?.gameFailedToStart()
        }
    }
    
    class Game {
        let start : CLLocation
        let end : CLLocation
        let name : String
        let url : String
        
        init(start: CLLocation, end: CLLocation, name: String, url: String) {
            self.start = start
            self.end = end
            self.name = name
            self.url = url
        }
        
        func backgroundColor() -> UIColor {
            return UIColor()
        }
        
        func destinationUrl() -> URL {
            return URL(string: self.url)!
        }
        
        func directiveText() -> String {
            return ""
        }
    }
}

protocol HotColdDelegate {
    func locationChanged()
    
    func gameStarted()
    
    func gameFailedToStart()
    
    func gameFinished()
}
