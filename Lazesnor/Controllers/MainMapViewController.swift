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

    var apiRequestManager: APIRequestManager?
    
    var locationManager: CLLocationManager!
    var isUserInteracting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        self.apiRequestManager = APIRequestManager()
        
        setupLocationManager()
        setUpViewHierarchy()
        addConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpViewHierarchy(){
        self.view.addSubview(mainMap)
        self.navigationItem.titleView = topContainerView
        
        self.topContainerView.addSubview(detailAlarmButton)
        self.topContainerView.addSubview(adressSearchBar)
        
    }

    func addConstraints(){
        //Constraints for mainMap
        var mainMapConstraints = [NSLayoutConstraint]()
        mainMapConstraints.append(mainMap.topAnchor.constraint(equalTo: self.view.topAnchor))
        mainMapConstraints.append(mainMap.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        mainMapConstraints.append(mainMap.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        mainMapConstraints.append(mainMap.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        _ = mainMapConstraints.map{ $0.isActive = true }
        
        //Constraints for top container view
        var topContainerViewConstraints = [NSLayoutConstraint]()
        topContainerViewConstraints.append(topContainerView.heightAnchor.constraint(equalToConstant: self.navigationController!.navigationBar.frame.height))
        topContainerViewConstraints.append(topContainerView.widthAnchor.constraint(equalToConstant: self.navigationController!.navigationBar.frame.width*0.9))
        _ = topContainerViewConstraints.map{ $0.isActive = true }
        
        //Constraints for detail button on navigation bar
        var detailButConstraints = [NSLayoutConstraint]()
        detailButConstraints.append(detailAlarmButton.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor))
        detailButConstraints.append(detailAlarmButton.heightAnchor.constraint(equalTo: topContainerView.heightAnchor))
        detailButConstraints.append(detailAlarmButton.widthAnchor.constraint(equalTo: topContainerView.heightAnchor))
        detailButConstraints.append(detailAlarmButton.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor))
        _ = detailButConstraints.map{ $0.isActive = true }
        
        //Constraints for search bar
        var searchBarConstraints = [NSLayoutConstraint]()
        searchBarConstraints.append(adressSearchBar.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor))
        searchBarConstraints.append(adressSearchBar.topAnchor.constraint(equalTo: adressSearchBar.topAnchor))
        searchBarConstraints.append(adressSearchBar.bottomAnchor.constraint(equalTo: adressSearchBar.bottomAnchor))
        searchBarConstraints.append(adressSearchBar.leadingAnchor.constraint(equalTo: detailAlarmButton.trailingAnchor, constant: 10))
        _ = searchBarConstraints.map{ $0.isActive = true }

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
    
    lazy var topContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var detailAlarmButton: UIButton = {
        let button = UIButton(type: UIButtonType.detailDisclosure)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var adressSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Destination"
        searchBar.delegate = self
        return searchBar
    }()
}

extension MainMapViewController: CLLocationManagerDelegate{
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    //MARK: - Core Location Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //current user location
        guard let currentLocation = locations.last, !isUserInteracting else { return }
        
        mainMap.animate(toLocation: currentLocation.coordinate)
        mainMap.animate(toZoom: 15)
    }
}

extension MainMapViewController: GMSMapViewDelegate{
    //MARK: - google map delegate functions
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        self.isUserInteracting = true
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.isUserInteracting = false
    }
    
}

extension MainMapViewController: UISearchBarDelegate{
    //MARK: - search bar delegate
}
