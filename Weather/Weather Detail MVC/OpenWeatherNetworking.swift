//
//  WeatherNetworking.swift
//  Weather
//
//  Created by Рома Сорока on 02.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

class OpenWeatherNetworking: WeatherNetworkingService {
  
  var urlSession = URLSession(configuration: URLSessionConfiguration.default)
  
  private let APP_ID = "4241061e2732492036c32da93c869d53"
  private let fiveDayForecastURL = URL(string: "http://api.openweathermap.org/data/2.5/forecast")!
  
  func get5DayWeather(lat: Double, lng: Double, responce: @escaping (Data?, Error?) -> ()) {
    let parameters = ["lat": String(lat),
                      "lon": String(lng),
                      "appid": APP_ID]
    
    let urlComp = NSURLComponents(url: fiveDayForecastURL, resolvingAgainstBaseURL: true)!
    
    var items = [URLQueryItem]()
    for (key,value) in parameters {
      items.append(URLQueryItem(name: key, value: value))
    }
    
    items = items.filter{!$0.name.isEmpty}
    if !items.isEmpty {
      urlComp.queryItems = items
    }
    
    var urlRequest = URLRequest(url: urlComp.url!)
    urlRequest.httpMethod = "GET"
    
    let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
      responce(data, error)
    }
    task.resume()
  }


  
  
  
}
