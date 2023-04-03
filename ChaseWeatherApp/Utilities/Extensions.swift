//
//  Extensions.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 4/2/23.
//

import Foundation

extension Double {
    func temperatureString(unit: TempatureUnit) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        guard let temperatureValue = formatter.string(from: NSNumber(value: self)) else {return "Could not format string"}
        
        switch unit {
        case .standard:
            return temperatureValue + "K"
        case .imperial:
            return temperatureValue + "°F"
        case .metric:
            return temperatureValue + "°C"
        }
        
    }
}
