//
//  LocationSearchViewController.swift
//  Lazesnor
//
//  Created by Tong Lin on 5/12/17.
//  Copyright © 2017 TongLin91. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class LocationSearchViewController: UIViewController {

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var locationManager: CLLocationManager?
    var apiRequestManager = APIRequestManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViewHierarchy()
        addConstraints()

        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 20.0, width: self.view.frame.width, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let currentLocation = locationManager!.location else { return }
        
        mainMap.animate(toLocation: currentLocation.coordinate)
        mainMap.animate(toZoom: 15)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDirectionsURL(origin: String, destination: String) -> URL?{
        // create URL using NSURLComponents
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "maps.googleapis.com"
        urlComponents.path = "/maps/api/directions/json"
        
        // add params
        let originQuery = URLQueryItem(name: "origin", value: origin)
        let destinationQuery = URLQueryItem(name: "destination", value: destination)
        let modeQuery = URLQueryItem(name: "mode", value: "transit")
        let alternativesQuery = URLQueryItem(name: "alternatives", value: "true")
        let apiKeyQuery = URLQueryItem(name: "key", value: "AIzaSyC5PPvciXYm4F0Pvgz9--uPZncuZcM8vTo")
        urlComponents.queryItems = [originQuery, destinationQuery, modeQuery, alternativesQuery, apiKeyQuery]
        
        print(urlComponents.url ?? "not valid url")
        return urlComponents.url
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

// MARK: - Core Location Delegate
extension LocationSearchViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //current user location
        guard let currentLocation = locations.last else { return }
        
        mainMap.animate(toLocation: currentLocation.coordinate)
        mainMap.animate(toZoom: 15)
    }
}

// MARK: - google map delegate functions
extension LocationSearchViewController: GMSMapViewDelegate{

    
}

// MARK: - Google place auto complete delegate
extension LocationSearchViewController: GMSAutocompleteResultsViewControllerDelegate{
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        
        let origin: String
        let destination = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
        if let currentCoor = locationManager!.location{
            origin = "\(currentCoor.coordinate.latitude),\(currentCoor.coordinate.longitude)"
        }else{
            print("Location manager unable to get current location")
            return
        }
        
        if let validAPI = getDirectionsURL(origin: origin, destination: destination){
            apiRequestManager.request(endPoint: validAPI, completion: { (data: Data?) in
                if let validData = data{
                    // Parsing routes
                    
                    let direction = Direction(validData)
                    dump(direction)
                    
                }
            })
        }
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
