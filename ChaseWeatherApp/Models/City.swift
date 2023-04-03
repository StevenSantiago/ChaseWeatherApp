//
//  City.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 4/1/23.
//

import Foundation

//Not supporting other languages besides english so not retriving local names
struct City: Decodable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
}
//
