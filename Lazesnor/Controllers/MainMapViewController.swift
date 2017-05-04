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

    var destinationCoor: CLLocationCoordinate2D?
    
    var apiRequestManager: APIRequestManager?
    var locationManager: CLLocationManager?
    var isUserInteracting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        self.apiRequestManager = APIRequestManager()
        
        setUpViewHierarchy()
        addConstraints()
        
        setupLocationManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDirectionsURL(origin: String, destination: String) -> URL?{
        // create URL using NSURLComponents
        var urlComponents = URLComponents()
        urlComponents.scheme = "https";
        urlComponents.host = "maps.googleapis.com";
        urlComponents.path = "/maps/api/directions/json?";
        
        // add params
        let originQuery = URLQueryItem(name: "origin", value: "Toronto")
        let destinationQuery = URLQueryItem(name: "destination", value: "Montreal")
        let modeQuery = URLQueryItem(name: "mode", value: "transit")
        let alternativesQuery = URLQueryItem(name: "alternatives", value: "true")
        let apiKeyQuery = URLQueryItem(name: "key", value: "AIzaSyC5PPvciXYm4F0Pvgz9--uPZncuZcM8vTo")
        urlComponents.queryItems = [originQuery, destinationQuery, modeQuery, alternativesQuery, apiKeyQuery]
        
        print(urlComponents.url ?? "not valid url")
        return urlComponents.url
    }
    
    func setUpViewHierarchy(){
        self.view.addSubview(mainMap)
//        self.navigationItem.titleView = topContainerView
//        
//        self.topContainerView.addSubview(detailAlarmButton)
//        self.topContainerView.addSubview(addressSearchBar)
        
    }

    func addConstraints(){
        //Constraints for mainMap
        var mainMapConstraints = [NSLayoutConstraint]()
        mainMapConstraints.append(mainMap.topAnchor.constraint(equalTo: self.view.topAnchor))
        mainMapConstraints.append(mainMap.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        mainMapConstraints.append(mainMap.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        mainMapConstraints.append(mainMap.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        _ = mainMapConstraints.map{ $0.isActive = true }
        
//        //Constraints for top container view
//        var topContainerViewConstraints = [NSLayoutConstraint]()
//        topContainerViewConstraints.append(topContainerView.heightAnchor.constraint(equalToConstant: self.navigationController!.navigationBar.frame.height))
//        topContainerViewConstraints.append(topContainerView.widthAnchor.constraint(equalToConstant: self.navigationController!.navigationBar.frame.width*0.9))
//        _ = topContainerViewConstraints.map{ $0.isActive = true }
//        
//        //Constraints for detail button on navigation bar
//        var detailButConstraints = [NSLayoutConstraint]()
//        detailButConstraints.append(detailAlarmButton.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor))
//        detailButConstraints.append(detailAlarmButton.heightAnchor.constraint(equalTo: topContainerView.heightAnchor))
//        detailButConstraints.append(detailAlarmButton.widthAnchor.constraint(equalTo: topContainerView.heightAnchor))
//        detailButConstraints.append(detailAlarmButton.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor))
//        _ = detailButConstraints.map{ $0.isActive = true }
//        
//        //Constraints for search bar
//        var searchBarConstraints = [NSLayoutConstraint]()
//        searchBarConstraints.append(addressSearchBar.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor))
//        searchBarConstraints.append(addressSearchBar.topAnchor.constraint(equalTo: addressSearchBar.topAnchor))
//        searchBarConstraints.append(addressSearchBar.bottomAnchor.constraint(equalTo: addressSearchBar.bottomAnchor))
//        searchBarConstraints.append(addressSearchBar.leadingAnchor.constraint(equalTo: detailAlarmButton.trailingAnchor, constant: 10))
//        _ = searchBarConstraints.map{ $0.isActive = true }

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
    
//    lazy var topContainerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    lazy var detailAlarmButton: UIButton = {
//        let button = UIButton(type: UIButtonType.detailDisclosure)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    lazy var addressSearchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchBar.placeholder = "Destination"
//        searchBar.delegate = self
//        return searchBar
//    }()
}

//MARK: - Core Location Delegate
extension MainMapViewController: CLLocationManagerDelegate{
    func setupLocationManager(){
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 50
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        self.locationManager = manager
        
    }
    
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

////MARK: - search bar delegate
//extension MainMapViewController: UISearchBarDelegate{
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let origin = "\(self.mainMap.myLocation?.coordinate.latitude) ,\(self.mainMap.myLocation?.coordinate.longitude)"
//        let destination =  "\(self.mainMap.myLocation?.coordinate.latitude) ,\(self.mainMap.myLocation?.coordinate.longitude)"
//        
//        if let validAPI = getDirectionsURL(origin: "Toronto", destination: "Montreal"){
//            apiRequestManager.request(endPoint: validAPI, completion: { (data: Data?) in
//                dump(data)
//            })
//        }
//        
//        self.addressSearchBar.resignFirstResponder()
//    }
//}





