//
//  WeatherResponce.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit

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
    let rain: Rain?
  }
  
  let list: [List]
  
  func weatherImage(forListItem number: Int) -> UIImage? {
    switch list[number].weather[0].id {
    case 0...300, 772...799, 900...902, 905...1000 :
      return UIImage(named: "stormCloud")
      
    case 301...500, 501...600 :
      return UIImage(named: "rainyCloud")
      
    case 701...771 :
      return UIImage(named: "outlinedSunnyCloud")
      
    case 800, 904 :
      return UIImage(named: "sun")
      
    case 801...804 :
      return UIImage(named: "cloud")

    default :
      return UIImage(named: "dunno")
    }
  }
  
}
