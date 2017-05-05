//
//  Bounds.swift
//  Lazesnor
//
//  Created by Tong Lin on 5/5/17.
//  Copyright © 2017 TongLin91. All rights reserved.
//

import Foundation
import CoreLocation

class Bounds {
    let northeastCoor: CLLocationCoordinate2D?
    let southwestCoor: CLLocationCoordinate2D?
    
    init(_ dict: [String: [String: Double]]) {
        if let northeast = dict["northeast"],
            let lat = northeast["lat"],
            let lng = northeast["lng"]{
            self.northeastCoor = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }else{
            print("Northeast bound coordinate not available")
            self.northeastCoor = nil
        }

        if let southwest = dict["southwest"],
           let lat = southwest["lat"],
           let lng = southwest["lng"]{
            self.southwestCoor = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }else{
            print("Southwest bound coordinate not available")
            self.southwestCoor = nil
        }
    }
}
