//
//  WeatherResponse.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 4/1/23.
//

import Foundation

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
    }
    
}
