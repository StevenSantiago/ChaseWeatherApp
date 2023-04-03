//
//  PersistenceManager.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 4/3/23.
//

import Foundation

struct PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let lastSearched = "lastSearchedLocation"
    }
    
    static func saveLastLocationSearched(locationName: String) {
        defaults.set(locationName, forKey: Keys.lastSearched)
    }
    
    static func retrieveLastLocationSearched() -> String? {
        guard let lastLocationSearched = defaults.object(forKey: Keys.lastSearched) as? String else {
            return nil
        }
        return lastLocationSearched
    }
}
