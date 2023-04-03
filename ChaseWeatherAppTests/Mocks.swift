//
//  Mocks.swift
//  ChaseWeatherAppTests
//
//  Created by Steven Santiago on 4/3/23.
//

import Foundation

extension WeatherResponse {
    static func mockOne() -> WeatherResponse {
        let main = Main(temp: 72.0)
        let weather = [Weather(id: 500, main: "Clouds", description: "overcast clouds", icon: "04d")]
        
        return WeatherResponse(coord: Coord(lon: 20.0, lat: 20.0), weather: weather, main: main, dt: 1661870592, name: "London")
    }
}
