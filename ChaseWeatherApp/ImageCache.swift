//
//  ImageCache.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 4/3/23.
//

import UIKit

//Singleton so that we dont have multiple caches being instantiated
class ImageCache {
    
    static let shared = ImageCache()
    let weatherIconEndpoint = "https://openweathermap.org/img/wn/"
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getImage(imageName: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: imageName as NSString) {
            completion(cachedImage)
            return
        }
        
        guard let url = URL(string: "\(weatherIconEndpoint)\(imageName)@2x.png") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: imageName as NSString)
                completion(image)
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
    
}
