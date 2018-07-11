//
//  City.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit.UIImage

struct City {
  let name: String
  let country: String
  let lat: Double
  let lng: Double
  var weatherImage: UIImage?
  var temperature: String?
  
  init(name: String, country: String, weatherImage: UIImage?, temperature: String?, lat: Double, lng: Double) {
    self.name = name
    self.country = country
    self.weatherImage = weatherImage
    self.temperature = temperature
    self.lat = lat
    self.lng = lng
  }
  
}

//MARK: JSON decoding

extension City: Decodable {
  enum CodingKeys: String, CodingKey {
    case coord
    case country
    case name
  }
  
  struct Coords: Decodable {
    let lat: Double
    let lon: Double
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    name = try container.decode(String.self, forKey: .name)
    country = try container.decode(String.self, forKey: .country)
    
    let coord = try container.decode(Coords.self, forKey: .coord)
    lat = coord.lat
    lng = coord.lon
    
  }
}
