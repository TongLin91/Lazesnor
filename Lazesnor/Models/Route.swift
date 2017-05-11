//
//  Route.swift
//  Lazesnor
//
//  Created by Tong Lin on 5/4/17.
//  Copyright © 2017 TongLin91. All rights reserved.
//

import Foundation


class Route {
    let bounds: Bounds
    let overviewPolyline: String
    let distance: String
    let duration: String
//    let steps: [Step]
    let nullStringHandler = "No data available"
    
    init(_ dict: [String: Any]) {
        if let mapBounds = dict["bounds"] as? [String: [String: Double]]{
            self.bounds = Bounds(mapBounds)
        }else{
            self.bounds = Bounds([String: [String: Double]]())
        }
        
        if let overview_polyline = dict["overview_polyline"] as? [String: String]{
            self.overviewPolyline = overview_polyline["points"] ?? ""
        }else{
            self.overviewPolyline = ""
        }
        
        guard let legs = dict["legs"] as? [Any],
            let leg = legs.first as? [String: Any] else{
                print("No transit available to input destination.")
                self.distance = "not available"
                self.duration = "not available"
//                self.steps = []
                return
        }
        
        if let distance = leg["distance"] as? [String: Any],
            let duration = leg["duration"] as? [String: Any] {
            self.distance = distance["text"] as? String ?? ""
            self.duration = duration["text"] as? String ?? ""
            
        }else{
            self.distance = nullStringHandler
            self.duration = nullStringHandler
        }
        
//        if let steps = leg["steps"] as? [[String: Any]]{
//            
//        }
        
        
    }
}
