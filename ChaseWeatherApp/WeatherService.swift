//
//  WeatherService.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 3/29/23.
//

import UIKit

//Only adding basic fields, no need to add other weather responses for now. Could be added as features later
struct WeatherResponse: Decodable {
    let coord: Coord?
    let weather: [Weather]
    let main: Main
    let dt: TimeInterval
    let name: String

    struct Coord: Decodable {
        let lon: Double
        let lat: Double
    }

    struct Weather: Decodable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    struct Main: Decodable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case humidity
        }
    }

}


    //Not supporting other languages besides english so not retriving local names
struct City: Decodable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
//
struct Coordinates {
    let longitude: Double
    let latitude: Double
}

enum WeatherError: Error {
    case generic
    case invalidURL
    case parsingError
    case noData
}

protocol WeatherServiceProtocol {
    func getWeatherByCoordinates(_ coordinates: Coordinates, completion: @escaping ((Result<WeatherResponse,WeatherError>) -> Void))
    func getGeoCoordinates(name: String, completion: @escaping((Result<[City],WeatherError>) -> Void))
    
    func fetchWeather(name: String, completion: @escaping((Result<WeatherResponse,WeatherError>) -> Void))
    
    func fetchWeatherIcon(imageName: String, completion: @escaping ((Result<UIImage,WeatherError>) -> Void))
}

class WeatherService: WeatherServiceProtocol {
    //If this were a production app, the API key would not be hardcoded here. It would be best to store at a server and handled there
    let apiKey = "d6ac97aefb928bedf0ba7d0937f92cda"
    let baseURL = "https://api.openweathermap.org"
    
    func getWeatherByCoordinates(_ coordinates: Coordinates, completion: @escaping ((Result<WeatherResponse,WeatherError>) -> Void)) {
        guard let weatherEndpoint = URL(string: "\(baseURL)/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(apiKey)")
        else {
            completion(.failure(.invalidURL))
            return
        }
                
        let task = URLSession.shared.dataTask(with: weatherEndpoint) { data,_,error in
            if error != nil {
                completion(.failure(.generic))
            }
            
            guard let data = data else {
                completion(.failure(.generic))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherResult = try decoder.decode(WeatherResponse.self, from: data)
                completion(.success(weatherResult))
            } catch {
                completion(.failure(.parsingError))
            }
            
        }
        
        task.resume()
                
    }


    func getGeoCoordinates(name: String, completion: @escaping((Result<[City],WeatherError>) -> Void)) {
        let urlString =  "\(baseURL)/geo/1.0/direct?q=\(name)&appid=\(apiKey)"
        guard let encodedUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let geoPathURL = URL(string: encodedUrlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: geoPathURL) { data,_,error in
            if error != nil {
                completion(.failure(.generic))
            }
            
            guard let data = data else {
                completion(.failure(.generic))
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                let cities = try decoder.decode([City].self, from: data)
                completion(.success(cities))
            } catch {
                completion(.failure(.parsingError))
            }
            
        }
        
        task.resume()
        
    }
    
    func fetchWeather(name: String, completion: @escaping((Result<WeatherResponse,WeatherError>) -> Void)) {
        getGeoCoordinates(name: name) { [weak self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let cities):
                guard let firstCity = cities.first else {
                    completion(.failure(.noData))
                    return
                }
                let coordinates = Coordinates(longitude: firstCity.lon, latitude: firstCity.lat)
                self?.getWeatherByCoordinates(coordinates) { weatherResult in
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
    
    func fetchWeatherIcon(imageName: String, completion: @escaping ((Result<UIImage,WeatherError>) -> Void)){
        guard let imagePathURL = URL(string:"https://openweathermap.org/img/wn/\(imageName)@2x.png") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: imagePathURL) { data, _, error in
            if error != nil {
                completion(.failure(.generic))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let weatherImage = UIImage(data: data) else {
                completion(.failure(.generic))
                return
            }
            
            completion(.success(weatherImage))
        }.resume()
        
    }
    
    
    
    
}
