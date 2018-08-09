//
//  WeatherModel.swift
//  Weather
//
//  Created by Рома Сорока on 02.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

class WeatherModel {
    var weatherResponce: WeatherResponce?
    
    private let forecastLoader: APIRequestLoader<FiveDayForecastRequest>?
    
    func get5DayWeatherForecast(city: WeatherCity,
                                completionHandler: @escaping (Response<WeatherResponce>) -> () ) {
        forecastLoader?.loadAPIRequest(requestData: city) { (weatherResponce, error) in
            self.weatherResponce = weatherResponce
            
            var resp: Response<WeatherResponce>
            if error == nil {
                resp = Response.success(weatherResponce!)
            } else {
                resp = Response.error(error!)
            }
            
            DispatchQueue.main.async {
                completionHandler(resp)
            }
            
        }
    }
    
    init(forecastService: APIRequestLoader<FiveDayForecastRequest>) {
        forecastLoader = forecastService
    }
}
