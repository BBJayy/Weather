//
//  CurrenWeatherRequest.swift
//  Weather
//
//  Created by Рома Сорока on 06.08.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

//class coz we often call parseResponce which needs a decoder and it would be inefficient to create it every time here
class CurrenWeatherRequest: OpenWeatherForecastRequest {
    var baseURL = URL(string: "http://api.openweathermap.org/data/2.5/weather")!
    lazy private var decoder = defaultDecoder
    
    func parseResponse(data: Data) throws -> WeatherResponce.Weather {
        return try decoder.decode(WeatherResponce.Weather.self, from: data)
    }
}
