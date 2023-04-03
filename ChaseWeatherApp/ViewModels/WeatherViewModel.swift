//
//  WeatherViewModel.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 4/1/23.
//

import CoreLocation
import UIKit


struct WeatherViewModel {
    var weatherService: WeatherServiceProtocol
    
    var locationTempObservable: Observable<String> = Observable(nil)
    var locationNameObservable: Observable<String> = Observable(nil)
    var locationWeatherDescription: Observable<String> = Observable(nil)
    var weatherImageObservable: Observable<UIImage> = Observable(nil)
    
    var noLocationFoundViewObservable: Observable<Bool> = Observable(false)
    
    //Provide defualt init so that I dont have to inject manually
    //If i had more time I would also inject the ImageCache here to mock image in tests
    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }
    
    func getWeatherFor(location: String) {
        weatherService.fetchWeather(name: location) { result in
            switch result {
            case .success(let weatherRes):
                PersistenceManager.saveLastLocationSearched(locationName: location)
                prepareWeatherDataForDisplay(weatherResponse: weatherRes)
            case .failure(let error):
                switch error {
                case .locationDNE:
                    DispatchQueue.main.async {
                        noLocationFoundViewObservable.value = true
                    }
                    
                default:
                    //we could show multiple different error views depending on what error cases we get right now
                    //Im only handling a location not existing from API
                    return
                    
                }
            }
        }
    }
    
    func getWeatherFor(location: CLLocation) {
        weatherService.getWeatherByCoordinates((latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { result in
            switch result {
            case .success(let weatherResponse):
                prepareWeatherDataForDisplay(weatherResponse: weatherResponse)
            case .failure(let error):
                print("Failed to getWeatherByLocation, error is \(error)")
            }
        }
    }
    
    func loadPreviousSearchedWeather() {
        guard let lastSearched = PersistenceManager.retrieveLastLocationSearched()
        else { return }
        
        getWeatherFor(location: lastSearched)
    }
    
    private func prepareWeatherDataForDisplay(weatherResponse: WeatherResponse) {
        DispatchQueue.main.async {
            noLocationFoundViewObservable.value = false
            locationTempObservable.value = weatherResponse.main.temp.temperatureString(unit: WeatherService.weatherUnits)
            locationNameObservable.value = weatherResponse.name
            
            //This is pulling the first possible weather condition for location, unsure how to present multiple
            //weather conditions for the user. If there is a weather response I assume there will be a description otherwise it will just clear it
            if let firstWeatherCondition = weatherResponse.weather.first {
                locationWeatherDescription.value = firstWeatherCondition.description
            } else {
                locationWeatherDescription.value = ""
            }
        }
        
        guard let imageName = weatherResponse.weather.first?.icon else {
            return
        }
        
        ImageCache.shared.getImage(imageName: imageName) { weatherImage in
            guard let image = weatherImage else {
                //If we had an image to show that icon couldnt be retrieved then we could show it here
                print("Image could not be fetched")
                return
            }
            DispatchQueue.main.async {
                weatherImageObservable.value = image
            }
        }
    }
    
}
