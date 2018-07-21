//
//  WeatherModel.swift
//  Weather
//
//  Created by Рома Сорока on 02.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

protocol WeatherForecastService {
  func get5DayWeather(lat: Double, lng: Double, responce: @escaping (Data?, Error?) -> ())
}

class WeatherModel {
  var weatherResponce: WeatherResponce?
  
  private var weatherNetworking: WeatherForecastService?
  
  private var decoder = JSONDecoder() {
    didSet {
      decoder.dateDecodingStrategy = .secondsSince1970
    }
  }

  
  func get5DayWeatherForecast(city: WeatherCity, responce: @escaping (Response<WeatherResponce>) -> () ) {
    weatherNetworking?.get5DayWeather(lat: city.lat, lng: city.lng) { [weak self] (data, error) in
      var resp: Response<WeatherResponce>

      defer {
        DispatchQueue.main.async {
          responce(resp)
        }
      }
      
      if error == nil {
        self?.weatherResponce = try! self!.decoder.decode(WeatherResponce.self, from: data!)
        resp = Response.success(self!.weatherResponce!)
      } else {
        resp = Response.error(error!)
      }
      
    }
  }
  
  init(networkingService: WeatherForecastService) {
    weatherNetworking = networkingService
  }
}
