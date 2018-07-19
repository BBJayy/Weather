//
//  HomeModel.swift
//  Weather
//
//  Created by Рома Сорока on 10.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit.UIImage

protocol WeatherCityStorage {
  func append(city: WeatherCity)
  func fetchCities() -> [WeatherCity]
}

class HomeModel {
  
  private let localStorage: WeatherCityStorage
  private var mapper: Mapper?
  
  var cityToChekout: WeatherCity?
  
  var savedCities = [WeatherCity]() {
    didSet {
      if let newCity = savedCities.last {
        localStorage.append(city: newCity)
      }
    }
  }
  
  init(storage: WeatherCityStorage) {
    self.localStorage = storage
    savedCities = localStorage.fetchCities()
    
  }
  

}

//MARK: Location

protocol Mapper {
  func getCityName(latitude: Double, longtitude: Double, responce: @escaping (Response<String>) -> ())
}

extension HomeModel {
  func set(mapper: Mapper) {
    self.mapper = mapper
  }
  
  func cityWith(latitude: Double, longitude: Double, complition: @escaping (WeatherCity?) -> Void ){
    mapper?.getCityName(latitude: latitude, longtitude: longitude) { (resp) in
      var city: WeatherCity? = nil
      switch resp {
      case .success(let name):
        city = WeatherCity(name: name, lat: Double(latitude), lng: Double(longitude), weatherImage: nil, temperature: nil)
        
      case .error(let err):
        print(err.localizedDescription)
        
      }
      complition(city)
    }
  }
}
