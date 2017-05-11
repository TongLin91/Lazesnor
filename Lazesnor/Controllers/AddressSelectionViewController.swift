//
//  AddressSelectionViewController.swift
//  Lazesnor
//
//  Created by Tong Lin on 5/4/17.
//  Copyright © 2017 TongLin91. All rights reserved.
//

import UIKit
import GooglePlaces

class AddressSelectionViewController: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var apiRequestManager = APIRequestManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        setUpViewHierarchy()
        addConstraints()
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
        
        self.view.addSubview(myHomeButton)
        self.view.addSubview(myWorkButton)
    }
    
    func addConstraints(){
        var myHomeButConstraints = [NSLayoutConstraint]()
        myHomeButConstraints.append(myHomeButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
        myHomeButConstraints.append(myHomeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -100))
        _ = myHomeButConstraints.map{ $0.isActive = true }
        
        var myWorkButConstraints = [NSLayoutConstraint]()
        myWorkButConstraints.append(myWorkButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
        myWorkButConstraints.append(myWorkButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 100))
        _ = myWorkButConstraints.map{ $0.isActive = true }
    }
    
    //MARK: - Lazy inits
    lazy var myHomeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Home", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var myWorkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Work", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
}

extension AddressSelectionViewController: GMSAutocompleteResultsViewControllerDelegate{
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.coordinate)")
        
        let mapView = MainMapViewController()
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 50
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.delegate = mapView
        mapView.locationManager = manager
        
        let origin: String
        let destination = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
        if let currentCoor = manager.location{
            origin = "\(currentCoor.coordinate.latitude),\(currentCoor.coordinate.longitude)"
        }else{
            print("no wifi connectivities")
            return
        }
        
        if let validAPI = getDirectionsURL(origin: origin, destination: destination){
            apiRequestManager.request(endPoint: validAPI, completion: { (data: Data?) in
                if let validData = data{
                    // Parsing routes
                    
                    mapView.direction = Direction(validData)
                    dump(mapView.direction)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        self.navigationController?.pushViewController(mapView, animated: true)
                    })
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
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
