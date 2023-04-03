//
//  Observable.swift
//  ChaseWeatherApp
//
//  Created by Steven Santiago on 4/1/23.
//

import Foundation

class Observable<T> {
    typealias Listener = ((T?) -> Void)
    
    var listener: Listener?
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    
    init(_ value: T?) {
        self.value = value
    }
    
    func bind(listener: @escaping Listener){
        self.listener = listener
        //Notify the current value if it was initilized with value
        listener(value)
    }
}
