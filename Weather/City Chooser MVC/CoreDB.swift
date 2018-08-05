//
//  CoreDB.swift
//  Weather
//
//  Created by Рома Сорока on 19.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit.UIApplication
import CoreData

class CoreDB: CitiesDBService {
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  typealias JSONDictionary = [String: Any]

  func loadAllCities(callback: @escaping ([Country]?, Error?) -> ()) {
    let request: NSFetchRequest<Country> = Country.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "initials", ascending: true)]
    
    var err: Error?
    var countries: [Country]?
    
    do {
      countries = try context.fetch(request)
    } catch {
      err = error
    }
    
    callback(countries, err)
  }
  
  func loadCitiesContainign(word: String, callback: @escaping ([City]?, Error?) -> ()) {
    let request: NSFetchRequest<City> = City.fetchRequest()
    request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", word)
    
    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
    var err: Error?
    var cities: [City]?
    
    do {
      cities = try context.fetch(request)
    } catch {
      err = error
    }
    
    callback(cities, err)
  }
  
  
  func setupDB() {
    let filepath = Bundle.main.url(forResource: "city.list", withExtension: "json")
    let data = try? Data(contentsOf: filepath!)
    
    var response: [Any]?
    var errorMessage = ""
    do {
      response = try JSONSerialization.jsonObject(with: data!, options: []) as? [Any]
    } catch let parseError as NSError {
      errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
      return
    }
    
    var countries = [Country]()
    
    for city in response! {
      let cityDictionary = city as! [String: Any]
      let cityName = cityDictionary["name"] as! String
      let countryInit = cityDictionary["country"] as! String
      let lat = (cityDictionary["coord"] as! [String: Any])["lat"] as! Double
      let lng = (cityDictionary["coord"] as! [String: Any])["lon"] as! Double
      
      let city = City(context: context)
      city.name = cityName
      city.lat = lat
      city.lng = lng
      
      
      if let i = countries.index(where: { $0.initials == countryInit }) {
        countries[i].addToCities(city)
      } else {
        let country = Country(context: context)
        country.cities = NSOrderedSet(object: city)
        country.initials = countryInit
        countries.append(country)
      }
      
    }
    
    saveContext()
    
  }
  
  func saveContext() {
    do {
      try context.save()
    } catch {
      fatalError(error.localizedDescription)
    }
  }
  
}
