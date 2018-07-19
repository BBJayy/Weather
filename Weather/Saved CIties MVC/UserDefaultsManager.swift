//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by Рома Сорока on 19.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation

class UserDefaultsManager: WeatherCityStorage {
  enum DefaultsKeys: String {
    case names
    case lats
    case lngs
  }
  
  
  private let defaults = UserDefaults.standard
  
  private var names = [String]()
  private var lngs = [Double]()
  private var lats = [Double]()
  
  func fetchCities() -> [WeatherCity] {
    names = defaults.array(forKey: DefaultsKeys.names.rawValue) as! [String]
    lats = defaults.array(forKey: DefaultsKeys.lats.rawValue) as! [Double]
    lngs = defaults.array(forKey: DefaultsKeys.lngs.rawValue) as! [Double]
    var cities = [WeatherCity]()
    cities.reserveCapacity(names.count)
    for i in 0..<names.count {
      let city = WeatherCity(name: names[i],
                             lat: lats[i] ,
                             lng: lngs[i],
                             weatherImage: nil,
                             temperature: nil)
      cities.append(city)
    }
    return cities
  }

  
  ///Appends and asynchronously saves shared UserDefaults
  func append(city: WeatherCity) {
    DispatchQueue.global(qos: .background).async {
      self.names.append(city.name)
      self.lngs.append(city.lng)
      self.lats.append(city.lat)
      self.defaults.set(self.names, forKey: DefaultsKeys.names.rawValue)
      self.defaults.set(self.lngs, forKey: DefaultsKeys.lngs.rawValue)
      self.defaults.set(self.lats, forKey: DefaultsKeys.lats.rawValue)
    }
  }
  
  
}
