//
//  WeatherForecastRequest.swift
//  Weather
//
//  Created by Рома Сорока on 06.08.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation
import CoreLocation

protocol OpenWeatherForecastRequest: APIRequest {
    var baseURL: URL { get set }
}

extension OpenWeatherForecastRequest {
    func makeRequest(from city: WeatherCity) throws -> URLRequest {
        let coord = CLLocationCoordinate2D(latitude: city.lat, longitude: city.lng)
        guard CLLocationCoordinate2DIsValid(coord) else {
            throw RequestError.invalidCoordinate
        }
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            else { throw RequestError.invalidURL }
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(coord.latitude)"),
            URLQueryItem(name: "lon", value: "\(coord.longitude)"),
            URLQueryItem(name: "appid", value: "4241061e2732492036c32da93c869d53")
        ]
        return URLRequest(url: components.url!)
    }
    
    var defaultDecoder: JSONDecoder {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .secondsSince1970
        return dec
    }
    
}



