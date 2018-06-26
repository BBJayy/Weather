//
//  City.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit

struct City: Decodable {
//  enum Weather: String, Decodable {
//    case cloud
//    case outlinedCloud
//    case outlinedSunnyCloud
//    case rainyCloud
//    case stormCloud
//    case sun
//    case dunno
//  }

  let name: String
  let country: String
  let lat: Float
  let lng: Float
  var weatherImage: UIImage?
  var temperature: String?
 
  enum CodingKeys: String, CodingKey {
    case lat
    case lng
    case country
    case name
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    country = try container.decode(String.self, forKey: .country)

    let latString = try container.decode(String.self, forKey: .lat)
    let lngString = try container.decode(String.self, forKey: .lng)
    lat = Float(latString)!
    lng = Float(lngString)!
    weatherImage = nil
    temperature = nil
  }
  
  init(name: String, country: String, weatherImage: UIImage, temperature: String, lat: Float, lng: Float) {
    self.name = name
    self.country = country
    self.weatherImage = weatherImage
    self.temperature = temperature
    self.lat = lat
    self.lng = lng
  }
  
}
