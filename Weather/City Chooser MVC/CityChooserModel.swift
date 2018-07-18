//
//  CityChooserModel.swift
//  Weather
//
//  Created by Рома Сорока on 11.07.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit.UIApplication
import CoreData

class CityChooserModel {
  
  typealias JSONDictionary = [String: Any]

  var countries: [Country]?
  var cities: [City]?
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  
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
  
  func loadCitiesFromDB(containing: String? = nil) {
    
    if containing == nil {
      let request: NSFetchRequest<Country> = Country.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(key: "initials", ascending: true)]
      cities = nil
      do {
        countries = try context.fetch(request)
      } catch {
        print("Error fetching data \(error)")
      }
    } else {
      let request: NSFetchRequest<City> = City.fetchRequest()
      
      if let wordPart = containing {
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", wordPart)
      }
      
      request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
      
      do {
        cities = try context.fetch(request)
      } catch {
        print("Error fetching search resuly \(error)")
      }
    }
    
    
    
  }
  
}
