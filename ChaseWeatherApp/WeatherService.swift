//
//  WeatherService.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 3/29/23.
//

import CoreLocation
import UIKit

protocol WeatherServiceProtocol {
    func getWeatherByCoordinates(_ coordinates: (latitude:Double, longitude: Double), completion: @escaping ((Result<WeatherResponse,WeatherError>) -> Void))
    func getGeoCoordinates(name: String, completion: @escaping((Result<[City],WeatherError>) -> Void))
    
    func fetchWeather(name: String, completion: @escaping((Result<WeatherResponse,WeatherError>) -> Void))
    
}

class WeatherService: WeatherServiceProtocol {
    //If this were a production app, the API key would not be hardcoded here. It would be best to store at a server and handled there
    let apiKey = "d6ac97aefb928bedf0ba7d0937f92cda"
    let baseURL = "https://api.openweathermap.org"
    
    //This should ideally live in user defaults so that user can switch this by preference, leaving it to save time
    static var weatherUnits = TempatureUnit.imperial
    
    func getWeatherByCoordinates(_ coordinates: (latitude: Double, longitude: Double), completion: @escaping ((Result<WeatherResponse,WeatherError>) -> Void)) {
        guard let weatherEndpoint = URL(string: "\(baseURL)/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)&units=\(WeatherService.weatherUnits.rawValue)")
        else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: weatherEndpoint) { data,_,error in
            if error != nil {
                completion(.failure(.generic))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherResult = try decoder.decode(WeatherResponse.self, from: data)
                completion(.success(weatherResult))
            } catch {
                completion(.failure(.parsingError))
            }
            
        }.resume()
        
    }
    
    
    func getGeoCoordinates(name: String, completion: @escaping((Result<[City],WeatherError>) -> Void)) {
        let urlString =  "\(baseURL)/geo/1.0/direct?q=\(name)&appid=\(apiKey)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let geoPathURL = URL(string: encodedUrlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: geoPathURL) { data,_,error in
            if error != nil {
                completion(.failure(.generic))
                return
            }
            
            guard let data = data else {
                completion(.failure(.generic))
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                let cities = try decoder.decode([City].self, from: data)
                //Check if the city data exists, can return a custom error if needed
                if cities.count > 0 {
                    completion(.success(cities))
                    
                } else {
                    print("There was no data for \(name)!")
                    completion(.failure(.locationDNE))
                }
                
                
                
            } catch {
                completion(.failure(.parsingError))
            }
        }.resume()
        
    }
    
    func fetchWeather(name: String, completion: @escaping((Result<WeatherResponse,WeatherError>) -> Void)) {
        getGeoCoordinates(name: name) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let cities):
                print("Fetching coordinates for these cities:")
                for city in cities {
                    print("\(city.name),\(city.state ?? "N/A")")
                }
                guard let firstCity = cities.first else {
                    print("There was no firstCity!")
                    completion(.failure(.noData))
                    return
                }
                
                self?.getWeatherByCoordinates((latitude: firstCity.lat, longitude: firstCity.lon)) { weatherResult in
                    switch weatherResult {
                    case .failure(let er):
                        completion(.failure(er))
                        
                    case .success(let weather):
                        completion(.success(weather))
                    }
                }
            }
        }
        
    }
    
    
}

