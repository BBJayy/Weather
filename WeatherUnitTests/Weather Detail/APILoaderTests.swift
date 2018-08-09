//
//  APILoaderTests.swift
//  WeatherUnitTests
//
//  Created by Рома Сорока on 08.08.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import XCTest
@testable import Weather

class APILoaderTests: XCTestCase {
    var loader: APIRequestLoader<FiveDayForecastRequest>!
    
    override func setUp() {
        let urlSessionConfig = URLSessionConfiguration.ephemeral
        urlSessionConfig.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: urlSessionConfig)
        loader = APIRequestLoader<FiveDayForecastRequest>(apiRequest: FiveDayForecastRequest(), urlSession: urlSession)
        
    }
    
    func testLoaderSuccessIntegration() {
        let city = WeatherCity(name: "TestCity", lat: 33.3, lng: 22.6, weatherImage: nil, temperature: nil)
        let url = Bundle(for: type(of: self)).url(forResource: "weatherForecast", withExtension: "json")
        let mockJSONData = try! Data(contentsOf: url!)
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.query?.contains("lat=33.3"), true)
            return (URLResponse(), mockJSONData)
        }
        
        let expectation = XCTestExpectation(description: "responce")
        loader.loadAPIRequest(requestData: city) { (responce, error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
    }
    
}
