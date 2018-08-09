//
//  FiveDayForecastRequestTests.swift
//  WeatherUnitTests
//
//  Created by Рома Сорока on 08.08.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import XCTest
@testable import Weather

class FiveDayForecastRequestTests: XCTestCase {
    let request = FiveDayForecastRequest()
    
    func testMakingRequest() throws {
       let city = WeatherCity(name: "TestCity", lat: 33.3, lng: 22.6, weatherImage: nil, temperature: nil)
        
        let urlRequest = try request.makeRequest(from: city)
        
        XCTAssertEqual(urlRequest.url?.scheme, "http")
        XCTAssertEqual(urlRequest.url?.host, "api.openweathermap.org")
        XCTAssertEqual(urlRequest.url?.pathComponents, ["/", "data", "2.5", "forecast"])
        XCTAssertEqual(urlRequest.url?.query, "lat=33.3&lon=22.6&appid=4241061e2732492036c32da93c869d53")
        
    }
    
    func testParsingResponce() throws {
        let testBundle = Bundle(for: type(of: self))
        let url = testBundle.url(forResource: "weatherForecast", withExtension: "json")!
        let data = try Data(contentsOf: url)
        
        let responceCity = try request.parseResponse(data: data)
        
        XCTAssertEqual(responceCity.timeStamps.count, 2)
        XCTAssertEqual(responceCity.timeStamps[0].temp, 299.62)
        XCTAssertEqual(responceCity.timeStamps[0].weatherImage, #imageLiteral(resourceName: "sun"))
        
        XCTAssertEqual(responceCity.timeStamps[1].temp, 299.45)
        XCTAssertEqual(responceCity.timeStamps[1].weatherImage, #imageLiteral(resourceName: "cloud"))
    }
}







