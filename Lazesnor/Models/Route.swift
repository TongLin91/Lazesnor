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
    
    
    init(_ dict: [String: Any]) {
        if let mapBounds = dict["bounds"] as? [String: [String: Double]]{
            self.bounds = Bounds(mapBounds)
        }else{
            self.bounds = Bounds([String: [String: Double]]())
        }
        
        if let overview_polyline = dict["overview_polyline"] as? [String: String] {
            self.overviewPolyline = overview_polyline["overview_polyline"] ?? ""
        }else{
            self.overviewPolyline = ""
        }
        
        if let legs = dict["legs"] as? [[String: Any]]{
            
        }else {
            print("No transit available to input destination.")
        }
        
    }
}
