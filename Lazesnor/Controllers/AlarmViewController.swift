//
//  AlarmViewController.swift
//  Lazesnor
//
//  Created by Tong Lin on 6/1/17.
//  Copyright © 2017 TongLin91. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AlarmViewController: UIViewController {

    var locationManager: CLLocationManager!
    var data: Direction!
    var miniMap: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        setUpViewHierarchy()
        addConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpViewHierarchy() {
        self.view.addSubview(miniMap)
    }
    
    func addConstraints() {
        
        //Constraints for mainMap
        var miniMapConstraints = [NSLayoutConstraint]()
        miniMapConstraints.append(miniMap.topAnchor.constraint(equalTo: self.view.topAnchor))
        miniMapConstraints.append(miniMap.bottomAnchor.constraint(equalTo: self.view.centerYAnchor))
        miniMapConstraints.append(miniMap.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        miniMapConstraints.append(miniMap.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        _ = miniMapConstraints.map{ $0.isActive = true }
        
    }
    
    

}
