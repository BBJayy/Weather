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

protocol CurrentWeatherSevice {
  func getWeather(lat: Double, lng: Double, complition: @escaping (Data?, Error?) -> () )
}

class HomeModel {
  
  private let localStorage: WeatherCityStorage
  private var mapper: Mapper?
  private var weatherDataSource: CurrentWeatherSevice?
  private let weatherDecoder = { () -> JSONDecoder in
    let dec = JSONDecoder()
    dec.dateDecodingStrategy = .secondsSince1970
    return dec
  }()
  
  var cityToChekout: WeatherCity?
  
  var savedCities = [WeatherCity]() {
    didSet {
      if let newCity = savedCities.last {
        localStorage.append(city: newCity)
      }
    }
  }
  
  init(storage: WeatherCityStorage, networking: CurrentWeatherSevice) {
    self.localStorage = storage
    self.weatherDataSource = networking
    savedCities = localStorage.fetchCities()
  }
  

}

//MARK: Weather Networking

extension HomeModel {
  func fetchCitiesWeather(complition: @escaping () -> ()) {
    DispatchQueue.global(qos: .userInteractive).async {
      let dg = DispatchGroup()
      for city in self.savedCities {
        dg.enter()
        DispatchQueue.global(qos: .userInteractive).async {
          self.weatherDataSource?.getWeather(lat: city.lat, lng: city.lng) { [unowned self] (data, error) in
            guard error == nil else {
              print("Error getting weather for city \(city.name): \(error!)")
              return
            }
            
            let weather = try! self.weatherDecoder.decode(WeatherResponce.Weather.self, from: data!)
            
            city.temperature = Int16(weather.temp - 273.15)
            city.weatherImage = weather.weatherImage
            dg.leave()
          }
        }
      }
      dg.notify(queue: DispatchQueue.main, execute: complition)
    }
    
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
