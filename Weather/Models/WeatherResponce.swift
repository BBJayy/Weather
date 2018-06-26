//
//  WeatherResponce.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

struct WeatherResponce: Decodable {
  
  struct List: Decodable {
    
    struct Main: Decodable {
      let temp: Float
      let humidity: Int
    }
    
    struct Weather: Decodable {
      let id: Int
    }
    
    struct Wind: Decodable {
      let speed: Float
    }
    
    struct Rain: Decodable {
      let percipation: Float?
      
      enum CodingKeys: String, CodingKey {
        case percipation = "3h"
      }
    }
    
    let dt: Date
    let main: Main 
    let weather: [Weather]
    let wind: Wind
    let rain: Rain
  }
  
  let list: [List]
  
}
