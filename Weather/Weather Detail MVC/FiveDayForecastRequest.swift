//
//  FiveDayForecastRequest.swift
//  Weather
//
//  Created by Рома Сорока on 06.08.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

struct FiveDayForecastRequest: OpenWeatherForecastRequest {
    var baseURL = URL(string: "http://api.openweathermap.org/data/2.5/forecast")!
    
    func parseResponse(data: Data) throws -> WeatherResponce {
        return try defaultDecoder.decode(WeatherResponce.self, from: data)
    }
}
