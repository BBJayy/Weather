//
//  MockOpenWeatherNetworking.swift
//  Weather
//
//  Created by Рома Сорока on 01.08.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

class MockOpenWeatherNetworking: WeatherForecastService {
  var succeded = true
  
  func get5DayWeather(lat: Double, lng: Double, responce: @escaping (Data?, Error?) -> ()) {
    var data: Data?
    var error: Error?
    
    if succeded {
      let url = Bundle.main.url(forResource: "weatherForecast", withExtension: "json")!
      data = try! Data(contentsOf: url)
    } else {
      error = NSError(domain:"", code: 404, userInfo: nil)
    }
    
    responce(data, error)

  }
  
  
}
