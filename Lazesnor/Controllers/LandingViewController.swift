//
//  LandingViewController.swift
//  Lazesnor
//
//  Created by Tong Lin on 5/11/17.
//  Copyright © 2017 TongLin91. All rights reserved.
//

import UIKit
import CoreLocation

class LandingViewController: UIViewController {

    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
        goHomeButton.addTarget(self, action: #selector(getDirection(sender:)), for: .touchUpInside)
        goWorkButton.addTarget(self, action: #selector(getDirection(sender:)), for: .touchUpInside)
        goSearchButton.addTarget(self, action: #selector(getDirection(sender:)), for: .touchUpInside)
        
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
        titleLabelConstraints.append(tableViewTitleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20))
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
