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
    
    var locationManager: CLLocationManager?
    var isUserInteracting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
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
        mainMapConstraints.append(mainMap.topAnchor.constraint(equalTo: self.view.topAnchor))
        mainMapConstraints.append(mainMap.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        mainMapConstraints.append(mainMap.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        mainMapConstraints.append(mainMap.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        _ = mainMapConstraints.map{ $0.isActive = true }
    }
    
    //MARK: - Lazy Inits
    lazy var mainMap: GMSMapView = {
        let mapView = GMSMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
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
        mapView.animate(toZoom: 12)
        mapView.isBuildingsEnabled = false
        mapView.isIndoorEnabled = false
        mapView.accessibilityElementsHidden = true
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.settings.indoorPicker = false
        mapView.delegate = self
        return mapView
    }()
}

//MARK: - Core Location Delegate
extension MainMapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //current user location
        guard let currentLocation = locations.last, !isUserInteracting else { return }
        
        mainMap.animate(toLocation: currentLocation.coordinate)
        mainMap.animate(toZoom: 15)
    }
}

//MARK: - google map delegate functions
extension MainMapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.isUserInteracting = true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.isUserInteracting = false
    }
    
}




