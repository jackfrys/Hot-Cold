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
    
    func makeRequest(_ type: String, radius: Double  ) {
        let url = URL(string: "hc.milodavis.com/getLocation.php?locType=\(type)&userLat=\(sharedInstance.currentLocation2d?.latitude)&userLong=\(sharedInstance.currentLocation2d?.longitude)&radius=\(radius)")
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
        println(NSString(data: data, encoding: String.Encoding.utf8))
            if("\(data)" == "NO RESULTS" ) {
                var alert = UIAlertView()
                alert.title = "No Relevant Results"
                alert.message = "Please try again!"
                alert.addButton(withTitle: "Later")
                alert.addButton(withTitle: "View")
                alert.show()
            }
            else {
                let json = JSON(data: data)
                let lat = json["latitude"].doubleValue
                let long = json["longitude"].doubleValue
                let name = json["name"].stringValue
                let link = json["link"].stringValue
                println("Destination: \(lat), \(long)")
            }
        }) 
        
        task.resume()
    }
    
}
