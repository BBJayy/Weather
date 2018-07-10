//
//  HomeModel.swift
//  Weather
//
//  Created by Рома Сорока on 10.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit.UIImage

class HomeModel {
  var savedCities = [City]()
  var cityToChekout: City?

  
  init() {
    let hurghada = City(name: "Hurghada", country: "Egypt", weatherImage: UIImage(named: "dunno")!, temperature: "? ℃", lat: 27.257896, lng: 33.811607)
    let newYork = City(name: "New York", country: "USA", weatherImage: UIImage(named: "dunno")!, temperature: "? ℃", lat: 40.712775, lng: -74.005973)
    savedCities.append(newYork)
    savedCities.append(hurghada)
  }
  
  func city(with latitude: Float, longitude: Float) -> City? {
    let geoCoder = CLGeocoder()
    let location = CLLocation(latitude: latitude, longitude: longitude)
    DispatchQueue.global()
    geoCoder.reverseGeocodeLocation(location, completionHandler: { [unowned self] (placemarks, error) -> Void in
      
      var placeMark: CLPlacemark!
      placeMark = placemarks?[0]
      
      guard let cityName = placeMark.subAdministrativeArea else { return nil }
      guard let countryName = placeMark.country else { return nil }
      
      return City(name: cityName, country: countryName, weatherImage: UIImage(named: "cloud")!, temperature: "4.0", lat: Float(latitude), lng: Float(longitude))
    }
  }
}
