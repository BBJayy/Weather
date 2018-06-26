//
//  CityChooserTableViewController.swift
//  Weather
//
//  Created by Рома Сорока on 26.06.2018.
//  Copyright © 2018 Рома Сорока. All rights reserved.
//

import UIKit

extension Character {
  func toUpper() -> Character {
    return String(self).uppercased().first!
  }
}


private let toWeatherCVIndentifier = "toWeatherVC"
private let reuseIdentifier = "CityCell"

class CityChooserTableViewController: UITableViewController {
  var cities = [City]()
  var countries = [String: [City]]()
  var sortedCountryInitials = [String]()

  let numberOfInitials = 246
  
  var selectedCellIndexPath: IndexPath?
  
  func city(at indexPath: IndexPath) -> City {
    let countryInitials = sortedCountryInitials[indexPath.section]
    let cityArray = countries[countryInitials]!
    return cityArray[indexPath.row]
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
      
      let filepath = Bundle.main.url(forResource: "citiesSmall", withExtension: "json")
      let data = try? Data(contentsOf: filepath!)
      cities = try! JSONDecoder().decode([City].self, from: data!)
      
      countries.reserveCapacity(numberOfInitials)
      sortedCountryInitials.reserveCapacity(numberOfInitials)
      for city in cities {
        let countryInitial = city.country
        if countries[countryInitial] != nil {
          countries[countryInitial]!.append(city)
        } else {
          sortedCountryInitials.append(countryInitial)
          countries[countryInitial] = [city]
        }
      }
      
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

  
  

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return countries.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countryInitials = sortedCountryInitials[section]
        return countries[countryInitials]!.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
      
      
      
      cell.textLabel?.text = city(at: indexPath).name
      
        return cell
    }
 
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sortedCountryInitials[section]
  }
  
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//    super.tableView(tableView, willSelectRowAt: indexPath)

    selectedCellIndexPath = indexPath
    tableView.deselectRow(at: indexPath, animated: true)
    
    return indexPath
  }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == toWeatherCVIndentifier {
        guard let weatherVC = segue.destination as? WeatherViewController else { fatalError("can't cast weatherVC") }
  
        weatherVC.city = city(at: selectedCellIndexPath!)
      }
    }
  
  //TODO: why can't do like this
//  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//    //    super.tableView(tableView, willSelectRowAt: indexPath)
//
//    performSegue(withIdentifier: toWeatherCVIndentifier, sender: city(at: indexPath))
//    tableView.deselectRow(at: indexPath, animated: true)
//
//    return indexPath
//  }
//
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == toWeatherCVIndentifier {
//      guard let weatherVC = segue.destination as? WeatherViewController else { fatalError("can't cast weatherVC") }
//      guard let senderCity = sender as? City else { fatalError("can't cast City") }
//
//      weatherVC.city = senderCity
//    }
//  }
  
  //MARK: sectionIndexTitles
//  override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//    return sortedCountryInitials
//  }

}
