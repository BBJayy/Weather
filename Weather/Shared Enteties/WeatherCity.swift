//
//  City.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit.UIImage

class WeatherCity {
  let name: String
  let lat: Double
  let lng: Double
  var weatherImage: UIImage?
  var temperature: Int16?
  
  init(name: String, lat: Double, lng: Double, weatherImage: UIImage?, temperature: Int16?) {
    self.name = name
    self.lat = lat
    self.lng = lng
    self.weatherImage = weatherImage
    self.temperature = temperature
  }
}
