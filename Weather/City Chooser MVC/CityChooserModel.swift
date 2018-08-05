//
//  CityChooserModel.swift
//  Weather
//
//  Created by Рома Сорока on 11.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import Foundation


@objc protocol CitiesDBService {
  @objc optional func setupDB()
  func loadAllCities(callback: @escaping ([Country]?, Error?) -> ())
  func loadCitiesContainign(word: String, callback: @escaping ([City]?, Error?) -> () )

}

class CityChooserModel {

  var countries: [Country]?
  var cities: [City]?
  
  private let database: CitiesDBService
  
  init(DB: CitiesDBService) {
    self.database = DB
  }
  
  //MARK: TableView funcs
  func country(at index: Int) -> Country {
    let sectionIndex = countries!.index(countries!.startIndex, offsetBy: index)
    return countries![sectionIndex]
  }
  
  func numberOfRows(in section: Int) -> Int {
    return cities == nil ? country(at: section).cities!.count : cities!.count
  }
  
  func city(at indexPath: IndexPath) -> City {
    if cities == nil {
      let sectionIndex = countries!.index(countries!.startIndex, offsetBy: indexPath.section)
      return countries![sectionIndex].cities![indexPath.row] as! City
    } else {
      return cities![indexPath.row]
    }
  }
  
  
  //MARK: Database connection
  
  func loadCitiesFromDB(containing: String? = nil, callback: @escaping (Response<Int>) -> () ) {
    if let wordPart = containing {
      database.loadCitiesContainign(word: wordPart) { (cities, error) in
        guard error == nil else {
          callback(Response<Int>.error(error!))
          return
        }
        self.cities = cities
        callback(Response<Int>.success(cities!.count))
      }
    } else {
      database.loadAllCities { (countries, error) in
        guard error == nil else {
          callback(Response<Int>.error(error!))
          return
        }
        self.countries = countries!
        self.cities = nil
        callback(Response<Int>.success(countries!.count))
      }
    }
    
    
    
    
  }
  
}
