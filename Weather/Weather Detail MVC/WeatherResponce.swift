//
//  WeatherResponce.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit.UIImage

struct WeatherResponce: Decodable {
  
  struct Weather: Decodable {
    
    private var imageID: Int
    let temp: Float
    let humidity: Int
    let windSpeed: Float
    var percipation: Float
    let date: Date
    
    var weatherImage: UIImage {
      switch imageID {
      case 0...300, 772...799, 900...902, 905...1000 :
        return UIImage(named: "stormCloud")!
        
      case 301...600 :
        return UIImage(named: "rainyCloud")!
        
      case 701...771 :
        return UIImage(named: "outlinedSunnyCloud")!
        
      case 800, 904 :
        return UIImage(named: "sun")!
        
      case 801...804 :
        return UIImage(named: "cloud")!
        
      default :
        return UIImage(named: "dunno")!
      }
    }
    

  }
  
  let timeStamps: [Weather]
  
}

//MARK: JSON Decoding stuff

extension WeatherResponce {
  enum CodingKeys: String, CodingKey {
    case timeStamps = "list"
  }
}

extension WeatherResponce.Weather {
  private struct Main: Decodable {
    let temp: Float
    let humidity: Int
  }
  
  private struct Weather: Decodable {
    let id: Int
  }
  
  private struct Wind: Decodable {
    let speed: Float
  }
  
  private struct Rain: Decodable {
    let percipation: Float?
    
    enum CodingKeys: String, CodingKey {
      case percipation = "3h"
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case date = "dt"
    case main
    case weather
    case wind
    case rain
  }
  
  init(from decoder: Decoder) throws {
    let conteiner = try decoder.container(keyedBy: CodingKeys.self)
    
    let main = try conteiner.decode(Main.self, forKey: .main)
    temp = main.temp
    humidity = main.humidity
    
    let weather = try conteiner.decode([Weather].self, forKey: .weather)
    imageID = weather.first!.id
    
    let wind = try conteiner.decode(Wind.self, forKey: .wind)
    windSpeed = wind.speed
    
    if conteiner.contains(.rain) {
      let rain = try conteiner.decode(Rain.self, forKey: .rain)
      percipation = rain.percipation ?? 0.0
    } else {
      percipation = 0.0
    }
    
    date = try conteiner.decode(Date.self, forKey: .date)
  }
}
