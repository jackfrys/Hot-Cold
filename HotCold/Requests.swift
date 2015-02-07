//
//  Created by Charlie Peters on 2/7/15.
//  Copyright (c) 2015 Jack Frysinger. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Requests {
    
    let loc = SharedLocation.sharedInstance
    
    init() {
    }

    // type is one of:
    // - "history"
    // - "restaurant"
    // - "museum"
    // - "park"
    // - "geocache"

    //radius is max radius wants to go
    
    //
    func makeRequest(type: String, radius: Double  ) {
        let url = NSURL(string: "hc.milodavis.com/getLocation.php?locType=\(type)&userLat=\(sharedInstance.currentLocation2d?.latitude)&userLong=\(sharedInstance.currentLocation2d?.longitude)&radius=\(radius)")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
        println(NSString(data: data, encoding: NSUTF8StringEncoding))
            if("\(data)" == "NO RESULTS" ) {
                var alert = UIAlertView()
                alert.title = "No Relevant Results"
                alert.message = "Please try again!"
                alert.addButtonWithTitle("Later")
                alert.addButtonWithTitle("View")
                alert.show()
            }
            else {
                let json = JSON(data: data)
                let lat = json["latitude"].doubleValue
                let long = json["longitude"].doubleValue
                let name = json["name"].stringValue
                let link = json["link"].stringValue
                self.loc.goalLocation = CLLocation(latitude: lat, longitude: long)
                self.loc.locationName = name
                self.loc.locationLink = link
            }
        }
        
        
        
        task.resume()
    }
    
}
