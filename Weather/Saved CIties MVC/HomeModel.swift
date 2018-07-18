//
//  HomeModel.swift
//  Weather
//
//  Created by Рома Сорока on 10.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit.UIImage
import CoreLocation

class HomeModel {
  
  enum DefaultsKeys: String {
    case names
    case lats
    case lngs
  }
  
  var savedCities = [WeatherCity]() {
    didSet {
      var names = [String]()
      var lngs = [Double]()
      var lats = [Double]()
      for city in savedCities {
        names.append(city.name)
        lngs.append(city.lng)
        lats.append(city.lat)
      }
      defaults.set(names, forKey: DefaultsKeys.names.rawValue)
      defaults.set(lngs, forKey: DefaultsKeys.lngs.rawValue)
      defaults.set(lats, forKey: DefaultsKeys.lats.rawValue)
    }
  }
  
  var cityToChekout: WeatherCity?

  
  let defaults = UserDefaults.standard
  
  init() {
    if let names = defaults.array(forKey: DefaultsKeys.names.rawValue),
       let lats = defaults.array(forKey: DefaultsKeys.lats.rawValue),
       let lngs = defaults.array(forKey: DefaultsKeys.lngs.rawValue) {
      savedCities.reserveCapacity(names.count)
      for i in 0..<names.count {
        let city = WeatherCity(name: names[i] as! String, lat: lats[i] as! Double, lng: lngs[i] as! Double, weatherImage: nil, temperature: nil)
        savedCities.append(city)
      }
    }
    
  }
  
  func cityWith(latitude: CLLocationDegrees, longitude: CLLocationDegrees, complition: @escaping (WeatherCity?) -> Void ){
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let geoCoder = CLGeocoder()
    let location = CLLocation(latitude: latitude, longitude: longitude)
   
    geoCoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: "eng"), completionHandler: { (placemarks, error) in
      
      let city: WeatherCity?
      defer {
        complition(city)
      }

      guard let placeMark = placemarks?[0],
            let cityName = placeMark.subAdministrativeArea
        else { city = nil; return }
      
      city = WeatherCity(name: cityName, lat: Double(latitude), lng: Double(longitude), weatherImage: nil, temperature: nil)
      
    })
    
    }
    
}
