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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = "Destination"
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        setUpViewHierarchy()
        addConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpViewHierarchy(){
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
        
        // Pass end coordinate to map view
        let mapView = MainMapViewController()
        mapView.destinationCoor = place.coordinate
        self.navigationController?.present(mapView, animated: true, completion: nil)
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
