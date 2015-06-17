//
//  DirectionsHandler.swift
//  HotCold
//
//  Created by David Alelyunas on 6/17/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import Foundation
import CoreLocation

class DirectionsHandler {
    
    private var apiKey = "AIzaSyAIZet_n9gbS3dDEaBkQ_a6BOLuJDEnYsI"
    private var start: CLLocation
    private var end: CLLocation
    private var directions: Array<CLLocation>
    private var locationPos = -1
    
    init(startLocation: CLLocation, endLocation: CLLocation ) {
        start = startLocation
        end = endLocation
        directions = [CLLocation]()
        getGoogleDirections()
    }
    
    // Returns the next endlocation in the directions
    // Returns nil if all of the endlocations have already been accessed
    func getNextEndLocation() -> CLLocation? {
        if(directions.count < locationPos) {
            return nil
        }
        locationPos += 1
        return directions[locationPos]
    }
    
    // Gets the path directions from the google api and unwraps the endlocations for the path 
    // and places them in the directions array
    private func getGoogleDirections() {
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=" +
            "\(start.coordinate.latitude),\(start.coordinate.longitude)&destination=" +
            "\(end.coordinate.latitude),\(end.coordinate.longitude)&mode=walking&key=\(apiKey)")
        
        var request: NSURLRequest = NSURLRequest(URL: url!)
        var response: NSURLResponse?
        
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil)
        
        let json = JSON(data: data!)
        println(json["routes"][0]["legs"][0]["steps"])
        
        var steps = json["routes"][0]["legs"][0]["steps"]
        for index in 1...steps.count {
            directions.append(CLLocation(latitude: steps[index]["end_location"]["lat"].doubleValue,
                longitude: steps[index]["end_location"]["lng"].doubleValue))
        }
        println(directions)
    }
    
}
