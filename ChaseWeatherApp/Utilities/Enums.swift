//
//  Enums.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 4/3/23.
//

import Foundation

enum WeatherError: Error {
    case generic
    case invalidURL
    case parsingError
    case noData
    case locationDNE
}

enum TempatureUnit: String {
    case standard
    case metric
    case imperial
}
