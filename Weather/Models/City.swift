//
//  City.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

struct City {
  enum Weather: String {
    case cloud
    case outlinedCloud
    case outlinedSunnyCloud
    case rainyCloud
    case stormCloud
    case sun
  }
  
  let name: String
  let weatherImageName: Weather?
  let temperature: String?
  
}
