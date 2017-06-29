//
//  LandingViewController.swift
//  Lazesnor
//
//  Created by Tong Lin on 5/11/17.
//  Copyright © 2017 TongLin91. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class LandingViewController: UIViewController {

    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var locationManager: CLLocationManager!
    var searchBarContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        goHomeButton.addTarget(self, action: #selector(getDirection(sender:)), for: .touchUpInside)
        goWorkButton.addTarget(self, action: #selector(getDirection(sender:)), for: .touchUpInside)
        goSearchButton.addTarget(self, action: #selector(getDirection(sender:)), for: .touchUpInside)
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        searchBarContainer = UIView(frame: CGRect(x: 0, y: 20.0, width: self.view.frame.width, height: 45.0))
        
        searchBarContainer.addSubview((searchController?.searchBar)!)
        view.addSubview(searchBarContainer)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        setupLocationManager()
        setUpViewHierarchy()
        addConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLocationManager() {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 50
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        self.locationManager = manager
    }
    
    func getDirection(sender: UIButton) {
        switch sender {
        case goHomeButton:
            print("Get home address.")
        case goWorkButton:
            print("Get work address.")
        case goSearchButton:
            print("Go location search view controller")
            let searchViewC = LocationSearchViewController()
            searchViewC.locationManager = self.locationManager
            
            self.present(searchViewC, animated: true, completion: { 
                //Delocate memory and location manager
            })
            
        default:
            print("Unknow button tapped.")
        }
    }
    
    func setUpViewHierarchy() {
        view.addSubview(tableViewTitleLabel)
        view.addSubview(historyTableView)
        view.addSubview(goSearchButton)
        view.addSubview(goHomeButton)
        view.addSubview(goWorkButton)
    }
    
    func addConstraints() {
        var titleLabelConstraints = [NSLayoutConstraint]()
        titleLabelConstraints.append(tableViewTitleLabel.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 20))
        titleLabelConstraints.append(tableViewTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        titleLabelConstraints.append(tableViewTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        _ = titleLabelConstraints.map{ $0.isActive = true }
        
        var historyTableConstraints = [NSLayoutConstraint]()
        historyTableConstraints.append(historyTableView.topAnchor.constraint(equalTo: self.tableViewTitleLabel.bottomAnchor, constant: 10))
        historyTableConstraints.append(historyTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10))
        historyTableConstraints.append(historyTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10))
        historyTableConstraints.append(historyTableView.bottomAnchor.constraint(equalTo: goSearchButton.topAnchor, constant: -50))
        _ = historyTableConstraints.map{ $0.isActive = true }
        
        var goHomeButtonConstraints = [NSLayoutConstraint]()
        goHomeButtonConstraints.append(goHomeButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor))
        goHomeButtonConstraints.append(goHomeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        _ = goHomeButtonConstraints.map{ $0.isActive = true }
        
        var goWorkButtonConstraints = [NSLayoutConstraint]()
        goWorkButtonConstraints.append(goWorkButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor))
        goWorkButtonConstraints.append(goWorkButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        _ = goWorkButtonConstraints.map{ $0.isActive = true }
        
        var goSearchButtonConstraints = [NSLayoutConstraint]()
        goSearchButtonConstraints.append(goSearchButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        goSearchButtonConstraints.append(goSearchButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor))
        _ = goSearchButtonConstraints.map{ $0.isActive = true }
    }
    
    //MARK: - Lazy inits
    lazy var goHomeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Home", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var goWorkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Work", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var goSearchButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    lazy var tableViewTitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.boldSystemFont(ofSize: 30)
        view.textAlignment = .center
        view.text = "Search History"
        view.textColor = .white
        return view
    }()
    
    lazy var historyTableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UINib(nibName: "SearchHistoryTableViewCell", bundle: nil) , forCellReuseIdentifier: "HistoryTableViewIdentifier")
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
}
// MARK: - History address table view delegate
extension LandingViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewIdentifier", for: indexPath) as!SearchHistoryTableViewCell
        
        cell.textLabel?.text = "address"
        
        return cell
    }
    
}

// MARK: - Google place auto complete delegate
extension LandingViewController: GMSAutocompleteResultsViewControllerDelegate{
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
        print(destination)
//        if let validAPI = getDirectionsURL(origin: origin, destination: destination){
//            apiRequestManager.request(endPoint: validAPI, completion: { (data: Data?) in
//                if let validData = data{
//                    // Parsing routes
//                    
//                    self.readyToSetupAlarm(Direction(validData))
//                    
//                }
//            })
//        }
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error) {
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

