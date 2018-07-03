//
//  WeatherModel.swift
//  Weather
//
//  Created by Рома Сорока on 02.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

protocol NetworkingService {
  func getRequest(_ url: URL, parameters: [String: String], responce: @escaping (Data?, Error?) -> ())
}

class WeatherModel {
  var weatherResponce: WeatherResponce?
  
  private var weatherNetworking: NetworkingService?
  var APP_ID = "4241061e2732492036c32da93c869d53"
  var fiveDayForecastURL = URL(string: "http://api.openweathermap.org/data/2.5/forecast")!
  
  func get5DayWeatherForecast(city: City, responce: @escaping (WeatherResponce?) -> () ) {
    
    let params = ["lat" : String(city.lat), "lon" : String(city.lng), "appid" : APP_ID]
    weatherNetworking?.getRequest(fiveDayForecastURL, parameters: params) { (data, error) in
      guard error == nil else { responce(nil); return }
      
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .secondsSince1970
      self.weatherResponce = try! decoder.decode(WeatherResponce.self, from: data!)
      
      DispatchQueue.main.async {
        responce(self.weatherResponce)
      }
    }
  }
  
  init(networkingService: NetworkingService) {
    weatherNetworking = networkingService
  }
}