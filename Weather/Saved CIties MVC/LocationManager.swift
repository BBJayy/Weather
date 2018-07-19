//
//  LocationManager.swift
//  Weather
//
//  Created by Рома Сорока on 19.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: Mapper {
  private let geoCoder = CLGeocoder()
  private let languageIdentifyer: String
  
  init(_ languageIdentifyer: String) {
    self.languageIdentifyer = languageIdentifyer
  }

  func getCityName(latitude: Double, longtitude: Double, responce: @escaping (Response<String>) -> ()) {
    let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longtitude))
    geoCoder.reverseGeocodeLocation(location, preferredLocale: Locale(identifier: languageIdentifyer)) { (placemarks, error) in
      var resp: Response<String>
      defer {
        responce(resp)
      }
      
      guard let placeMark = placemarks?[0],
        let cityName = placeMark.subAdministrativeArea
        else { resp = Response.error(error!); return }
      
      resp = Response.success(cityName)
      
    }
  }
    
}
  

