//
//  City.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit.UIImage

struct WeatherCity {
  let name: String
  let id: Int32?
  let lat: Double
  let lng: Double
  var weatherImage: UIImage?
  var temperature: Int16?
  
}
