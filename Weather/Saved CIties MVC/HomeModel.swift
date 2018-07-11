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
  var savedCities = [City]()
  var cityToChekout: City?

  
  init() {
    let hurghada = City(name: "Hurghada",
                        country: "Egypt",
                        weatherImage: UIImage(named: "dunno")!,
                        temperature: "? ℃",
                        lat: 27.257896,
                        lng: 33.811607)
    let newYork = City(name: "New York",
                       country: "USA",
                       weatherImage: UIImage(named: "dunno")!,
                       temperature: "? ℃",
                       lat: 40.712775,
                       lng: -74.005973)
    
    savedCities.append(newYork)
    savedCities.append(hurghada)
  }
  
  func cityWith(latitude: CLLocationDegrees, longitude: CLLocationDegrees, complition: @escaping (City?) -> Void ){
    let geoCoder = CLGeocoder()
    let location = CLLocation(latitude: latitude, longitude: longitude)
   
    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
      
      let city: City?
      defer {
        complition(city)
      }

      guard let placeMark = placemarks?[0],
            let cityName = placeMark.subAdministrativeArea,
            let countryName = placeMark.isoCountryCode
        else { city = nil; return }
      
      city = City(name: cityName,
                  country: countryName,
                  weatherImage: nil,
                  temperature: nil,
                  lat: Double(latitude),
                  lng: Double(longitude))

    })
    
    }
    
}
