//
//  MainMapViewController.swift
//  Lazesnor
//
//  Created by Tong Lin on 4/27/17.
//  Copyright © 2017 TongLin91. All rights reserved.
//

import UIKit
import GoogleMaps

class MainMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        setUpViewHierarchy()
        addConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpViewHierarchy(){
        self.view.addSubview(mainMap)

    }

    func addConstraints(){
        //Constraints for mainMap
        var mainMapConstraints = [NSLayoutConstraint]()
        
        let mapTopConst = mainMap.topAnchor.constraint(equalTo: self.view.topAnchor)
        mainMapConstraints.append(mapTopConst)
        
        let mapBotConst = mainMap.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        mainMapConstraints.append(mapBotConst)
        
        let mapLeadConst = mainMap.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        mainMapConstraints.append(mapLeadConst)
        
        let mapTraiConst = mainMap.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        mainMapConstraints.append(mapTraiConst)
        
        _ = mainMapConstraints.map{ $0.isActive = true }
    }
    
    //MARK: - Lazy Inits
    lazy var mainMap: GMSMapView = {
        let camera = GMSCameraPosition.camera(withLatitude: 40.743924, longitude: -73.948802, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "MyMapStyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find MyMapStyle.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.accessibilityElementsHidden = true
        mapView.isIndoorEnabled = false
        return mapView
    }()
}

extension MainMapViewController: GMSMapViewDelegate{
    //MARK: - google map delegate functions
    
    
}
