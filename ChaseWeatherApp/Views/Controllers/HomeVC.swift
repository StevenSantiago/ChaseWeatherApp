//
//  HomeVC.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 3/29/23.
//

import CoreLocation
import UIKit

class HomeVC: UIViewController {
    
    let searchBarView = SearchBarView()
    let weatherView = WeatherStackView()
    let noLocationFoundLabel = UILabel()
    
    var weatherViewModel: WeatherViewModel
    
    //To save time I will leave this location manager class here, ideally you could also move this to a seperate class
    //like WeatherViewModel or the Service
    let locationManager = CLLocationManager()
    
    init(weatherViewModel: WeatherViewModel) {
        self.weatherViewModel = weatherViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setUpViews()
        setUpBinding()
        setupCLLocation()
    }
    
    private func setUpViews() {
        searchBarView.searchBar.delegate = self
        view.addSubview(searchBarView)
        view.addSubview(weatherView)
        view.addSubview(noLocationFoundLabel)
        
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        noLocationFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            searchBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            weatherView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: 20),
            weatherView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            noLocationFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noLocationFoundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupCLLocation() {
        locationManager.delegate = self
        locationManager.distanceFilter = 1000 //Using this so the device doesnt update frequently, this is 1000 meters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //Check if user has granted permission
        switch locationManager.authorizationStatus {
        case .notDetermined, .denied:
            weatherViewModel.loadPreviousSearchedWeather()
        default:
            print("Loaded current location weather!")
        }
    }
    
    private func setUpBinding() {
        weatherViewModel.locationNameObservable.bind { [weak self] name in
            guard let cityName = name else {return}
            self?.weatherView.cityLabel.text = cityName
        }
        weatherViewModel.locationTempObservable.bind { [weak self] temp in
            guard let cityTemp = temp else {return}
            self?.weatherView.tempatureLabel.text = cityTemp
        }
        
        weatherViewModel.weatherImageObservable.bind { [weak self] weatherIcon in
            guard let image = weatherIcon else {return}
            self?.weatherView.weatherImageView.image = image
        }
        
        weatherViewModel.locationWeatherDescription.bind { [weak self] description in
            guard let weatherDescription = description else {return}
            self?.weatherView.weatherDescriptionLabel.text = weatherDescription
        }
        
        weatherViewModel.noLocationFoundViewObservable.bind { [weak self] show in
            guard let showView = show else {return}
            self?.noLocationFoundLabel.text = "Location Not Found!"
            self?.noLocationFoundLabel.isHidden = !showView
            self?.weatherView.isHidden = showView
        }
        
        
    }
}


extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let userInput = searchBar.text else {
            return
        }
        searchBar.resignFirstResponder()
        weatherViewModel.getWeatherFor(location: userInput)
        
    }
    
}

extension HomeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        let longitude = location.coordinate.longitude
        let latitude = location.coordinate.latitude
        let clLocation = CLLocation(latitude: latitude, longitude: longitude)
        weatherViewModel.getWeatherFor(location: clLocation)
    }
}

