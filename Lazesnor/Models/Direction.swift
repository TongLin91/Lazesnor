//
//  Direction.swift
//  Lazesnor
//
//  Created by Tong Lin on 5/4/17.
//  Copyright © 2017 TongLin91. All rights reserved.
//

import Foundation

class Direction {
    var originPlaceID: String
    var destinationPlaceID: String
    var routes: [Route]
    
    init(originPlaceID: String, destinationPlaceID: String, routes: [Route]) {
        self.originPlaceID = originPlaceID
        self.destinationPlaceID = destinationPlaceID
        self.routes = routes
    }
    
    convenience init?(_ validData: Data) {
        do {
            let dict = try JSONSerialization.jsonObject(with: validData, options: []) as! [String: Any]
            
            guard let waypoints = dict["geocoded_waypoints"] as? [[String: Any]],
                let origin = waypoints[0]["place_id"] as? String,
                let destination = waypoints[1]["place_id"] as? String
                else {
                    print("error parsing place id for origin and destination")
                    return nil
            }
            
            guard let routeDict = dict["routes"] as? [[String: Any]] else {
                self.init(originPlaceID: origin, destinationPlaceID: destination, routes: [])
                return
            }
            
            let routes = routeDict.map{ Route($0) }
            
            self.init(originPlaceID: origin, destinationPlaceID: destination, routes: routes)
            return
        } catch {
            print("error parsing direction data")
        }
        
        return nil
    }
}
