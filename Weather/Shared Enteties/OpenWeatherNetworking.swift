//
//  WeatherNetworking.swift
//  Weather
//
//  Created by Рома Сорока on 02.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

class OpenWeatherNetworking: WeatherForecastService, CurrentWeatherSevice {

  private let urlSession = URLSession(configuration: URLSessionConfiguration.default)
  
  private let APP_ID = "4241061e2732492036c32da93c869d53"
  private let fiveDayForecastURL = URL(string: "http://api.openweathermap.org/data/2.5/forecast")!
  private let currentWeatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather")!
  
  private func getRerquestWith(params: [String: String], url: URL) -> URLRequest {
    let urlComp = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
    
    var items = [URLQueryItem]()
    for (key,value) in params {
      items.append(URLQueryItem(name: key, value: value))
    }
    
    items = items.filter{!$0.name.isEmpty}
    if !items.isEmpty {
      urlComp.queryItems = items
    }
    
    var urlRequest = URLRequest(url: urlComp.url!)
    urlRequest.httpMethod = "GET"
    
    return urlRequest
  }
  
  func get5DayWeather(lat: Double, lng: Double, responce: @escaping (Data?, Error?) -> ()) {
    let params = ["lat": String(lat),
                  "lon": String(lng),
                  "appid": APP_ID ]
    let getReq = getRerquestWith(params: params, url: fiveDayForecastURL)
    
    let task = urlSession.dataTask(with: getReq) { (data, response, error) in
      responce(data, error)
    }
    task.resume()
  }

  
  func getWeather(lat: Double, lng: Double, complition: @escaping (Data?, Error?) -> ()) {
    let params = ["lat": String(lat),
                  "lon": String(lng),
                  "appid": APP_ID ]
    let getReq = getRerquestWith(params: params, url: currentWeatherURL)
    
    let task = urlSession.dataTask(with: getReq) { (data, response, error) in
      complition(data, error)
    }
    task.resume()
  }
  
  
}
