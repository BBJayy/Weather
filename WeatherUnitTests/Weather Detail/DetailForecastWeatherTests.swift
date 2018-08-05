//
//  NetworkingWeatherTests.swift
//  NetworkingWeatherTests
//
//  Created by Рома Сорока on 31.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import XCTest
@testable import Weather

class DetailForecastWeatherTests: XCTestCase {
  var weatherModel: WeatherModel!
  var mockOpenWeatherNetworking = MockOpenWeatherNetworking()
  let cityToLookup = WeatherCity(name: "London", lat: 35.0, lng: 22.0, weatherImage: nil, temperature: nil)
  
  
  
  override func setUp() {
    super.setUp()
    
    weatherModel = WeatherModel(networkingService: mockOpenWeatherNetworking)
  }
  
  override func tearDown() {
    weatherModel = nil
    super.tearDown()
  }
  
  func testForecastFailed() {
    mockOpenWeatherNetworking.succeded = false
    let failPromice = expectation(description: "Weather forecast failed as expected")
    weatherModel.get5DayWeatherForecast(city: cityToLookup) { (responce) in
      switch responce {
      case .success:
        XCTFail()
      case .error:
        failPromice.fulfill()
      }
    }
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testForecastSucceded() {
    mockOpenWeatherNetworking.succeded = true
    let successPromice = expectation(description: "Weather forecast gathered")
    weatherModel.get5DayWeatherForecast(city: cityToLookup) { (responce) in
      switch responce {
      case .success:
        successPromice.fulfill()
      case .error(let err):
        XCTFail(err.localizedDescription)
      }
    }
    waitForExpectations(timeout: 5, handler: nil)
  }
  
  func testDecoding() {
    let testedJSON = Bundle.main.url(forResource: "weatherForecast", withExtension: "json")
    //let weatherResponce = weatherModel.
  }
  
  
  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
