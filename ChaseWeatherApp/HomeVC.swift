//
//  HomeVC.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 3/29/23.
//

import UIKit

class HomeVC: UIViewController {
    
    let searchBar = UISearchBar()
    //This is protocol so that it can be easier to mock out calls instead of relying on live connection for tests
    var weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemTeal
        setUpSearchBar()
        // Do any additional setup after loading the view.
    }
    
    private func setUpSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.placeholder = "Enter City"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    
}

//TODO: AutoComplete Cities might be nice feature at the end, this prevents user from mistyping city and not finding a valid result

extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Retrieving weather for location!")
        guard let userInput = searchBar.text else {
            return
        }
        
        print("City weather for \(userInput) being retrieved!")
        weatherService.fetchWeather(name: userInput) { result in
            switch result {
            case .success(let weatherRes):
                print("Weather \(weatherRes)")
                guard let imageName = weatherRes.weather.first?.icon else {
                    return
                }
                self.weatherService.fetchWeatherIcon(imageName: imageName) { result in
                    switch result {
                    case .success(let image):
                        print("Image will update UI here")
                    case .failure(let error):
                        print("Image could not be fetched")
                    }
                }
            case .failure(let error):
                print("Error is: \(error)")
            }
        }
        
    }
}

