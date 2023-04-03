//
//  WeatherViewModelTests.swift
//  ChaseWeatherAppTests
//
//  Created by Steven Santiago on 4/3/23.
//

import XCTest
@testable import ChaseWeatherApp

class WeatherViewModelTests: XCTestCase {
    var weatherService: MockWeatherService!
    var viewModel: WeatherViewModel!

    override func setUp() {
        super.setUp()
        weatherService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: weatherService)
    }

    override func tearDown() {
        weatherService = nil
        viewModel = nil
        super.tearDown()
    }

    //Note this does still access the live network due to the image cache class reaching out
    //
    func testFetchWeatherForValidLocation() {
        let expectation = XCTestExpectation(description: "Weather data should be fetched for a valid location")

        weatherService.mockWeatherResponse = .success(WeatherResponse.mockOne())

        viewModel.getWeatherFor(location: "London")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            XCTAssertEqual(self.viewModel.locationTempObservable.value, "72°F")
            XCTAssertNotNil(self.viewModel.locationNameObservable.value, "London")
            XCTAssertNotNil(self.viewModel.locationWeatherDescription.value, "overcast clouds")
            XCTAssertFalse(self.viewModel.noLocationFoundViewObservable.value ?? true)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3.0)
    }

    func testFetchWeatherForInvalidLocation() {
        let expectation = XCTestExpectation(description: "No location found view should be shown for an invalid location")

        weatherService.mockWeatherResponse = .failure(.locationDNE)

        viewModel.getWeatherFor(location: "Invalid Location")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNil(self.viewModel.locationTempObservable.value)
            XCTAssertNil(self.viewModel.locationNameObservable.value)
            XCTAssertNil(self.viewModel.locationWeatherDescription.value)
            XCTAssertNil(self.viewModel.weatherImageObservable.value)
            XCTAssertTrue(self.viewModel.noLocationFoundViewObservable.value ?? false)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)
    }

}

class MockWeatherService: WeatherServiceProtocol {

    
    var mockWeatherResponse: Result<WeatherResponse,WeatherError>?
    
    func fetchWeather(name: String, completion: @escaping ((Result<WeatherResponse, WeatherError>) -> Void)) {
        if let response = mockWeatherResponse {
            completion(response)
        } else {
            completion(.failure(.generic))
        }
    }
    
    //Will not use fill out below since I am not testing these. If I had more time I would
    func getWeatherByCoordinates(_ coordinates: (latitude: Double, longitude: Double), completion: @escaping ((Result<WeatherResponse, WeatherError>) -> Void)) {
        //
    }
    
    func getGeoCoordinates(name: String, completion: @escaping ((Result<[City], WeatherError>) -> Void)) {
        
    }

}
